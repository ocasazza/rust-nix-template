{
  description = "Build a cargo project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
    rust-bin.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      flake-utils,
      advisory-db,
      rust-bin,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-bin.overlays.default ];
        };
        inherit (pkgs) lib;
        craneLib = crane.mkLib pkgs;
        rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        src = pkgs.lib.cleanSourceWith {
          src = ./.;
          name = "rust_nix_template-src";
          filter = name: type:
            pkgs.lib.cleanSourceFilter name type
            || (pkgs.lib.hasInfix "/rust-toolchain.toml" name);
        };
        # Common arguments can be set here to avoid repeating them later
        commonArgs = {
          inherit src;
          strictDeps = true;
          buildInputs = [
            # Add additional build inputs here
            rustToolchain
          ];
          # Additional environment variables can be set directly
          # MY_CUSTOM_VAR = "some value";
        };

        # Build *just* the cargo dependencies, so we can reuse
        # all of that work (e.g. via cachix) when running in CI
        cargoArtifacts = craneLib.buildDepsOnly commonArgs;
        # Build the actual crate itself, reusing the dependency
        # artifacts from above.
        my-crate = craneLib.buildPackage (commonArgs // { inherit cargoArtifacts; });
      in
      {
        checks = {
          # Build the crate as part of `nix flake check` for convenience
          inherit my-crate;
          # Run clippy (and deny all warnings) on the crate source,
          # again, reusing the dependency artifacts from above.
          my-crate-clippy = craneLib.cargoClippy (
            commonArgs // {
              inherit cargoArtifacts;
              cargoClippyExtraArgs = "--all-targets -- --deny warnings";
            }
          );
          my-crate-doc = craneLib.cargoDoc (commonArgs // { inherit cargoArtifacts; });
          # Check formatting
          my-crate-fmt = craneLib.cargoFmt { inherit src; };
          my-crate-toml-fmt = craneLib.taploFmt {
            src = pkgs.lib.sources.sourceFilesBySuffices src [ ".toml" ];
            # taplo arguments can be further customized below as needed
            # taploExtraArgs = "--config ./taplo.toml";
          };
          # Audit dependencies
          my-crate-audit = craneLib.cargoAudit {
            inherit src advisory-db;
          };
          # Audit licenses
          my-crate-deny = craneLib.cargoDeny {
            inherit src;
          };
          # Run tests with cargo-nextest
          # Consider setting `doCheck = false` on `my-crate` if you do not want
          # the tests to run twice
          my-crate-nextest = craneLib.cargoNextest (
            commonArgs
            // {
              inherit cargoArtifacts;
              partitions = 1;
              partitionType = "count";
              cargoNextestPartitionsExtraArgs = "--no-tests=pass";
            }
          );
        };
        packages = {
          default = my-crate;
        };
        apps = {
          default = flake-utils.lib.mkApp {
            drv = my-crate;
          };
          coverage = {
            type = "app";
            program = "${pkgs.writeShellScript "coverage-app" ''
              set -e
              echo "--- Installing cargo-tarpaulin for coverage ---"
              # Use cargo-tarpaulin which works better in Nix environments
              if ! command -v cargo-tarpaulin &> /dev/null; then
                cargo install cargo-tarpaulin
              fi
              # Clean previous coverage data
              rm -rf target/coverage
              mkdir -p target/coverage
              # Generate coverage with tarpaulin
              cargo tarpaulin --out Html --output-dir target/coverage/html
              cargo tarpaulin --out Lcov --output-dir target/coverage
            ''}";
          };
          docs = {
            type = "app";
            program = "${pkgs.writeShellScript "docs-app" ''
              set -e
              export PATH=$HOME/.cargo/bin:$PATH
              unset RUSTFLAGS
              unset LLVM_PROFILE_FILE
              unset CARGO_INCREMENTAL
              if [ ! -d ".venv" ]; then
                python -m venv .venv
              fi
              source .venv/bin/activate
              pip install -r requirements.txt
              sphinx-multiversion docs/source docs/build/html
            ''}";
          };
          clean-docs = {
            type = "app";
            program = "${pkgs.writeShellScript "serve-docs-app" ''
              rm -rf docs/build
            ''}";
          };
          serve-docs = {
            type = "app";
            program = "${pkgs.writeShellScript "serve-docs-app" ''
              set -e
              export PATH=$HOME/.cargo/bin:$PATH
              unset RUSTFLAGS
              unset LLVM_PROFILE_FILE
              unset CARGO_INCREMENTAL
              if [ ! -d ".venv" ]; then
                python -m venv .venv
              fi
              source .venv/bin/activate
              pip install -r requirements.txt
              sphinx-multiversion docs/source docs/build/html
              python -m http.server --directory docs/build/html 8000
              echo "--- docs serving at http://localhost:8000 ---"
            ''}";
          };
        };
        devShells.default = craneLib.devShell {
          # Inherit inputs from checks.
          checks = self.checks.${system};
          # Additional dev-shell environment variables can be set directly
          RUSTFLAGS = "-C instrument-coverage";
          LLVM_PROFILE_FILE = "target/coverage/cargo-test-%p-%m.profraw";
          CARGO_INCREMENTAL = "0";
          # Extra inputs can be added here; cargo and rustc are provided by default.
          packages = with pkgs; [
            grcov
            llvmPackages.llvm # Re-adding llvmPackages.llvm for runtime libraries
            git
            python3
            python3Packages.pip
            python3Packages.virtualenv
            cargo # Needed for sphinx-rustdocgen installation
          ];
          # Use the rustToolchain defined above
          buildInputs = [ rustToolchain ];
        };
      }
    );
}
