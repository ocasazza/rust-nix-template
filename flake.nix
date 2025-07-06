{
  description = "A professional Rust template with Nix, Sphinx docs, and automated releases";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable."1.77.2".default.override {
          extensions = [ "rust-src" ];
        };

        craneLib = pkgs.crane;

        release-plz-src = pkgs.fetchFromGitHub {
          owner = "release-plz";
          repo = "release-plz";
          rev = "v0.5.30";
          sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, will be filled by Nix
        };

        # Build release-plz-cli from source
        release-plz-cli = craneLib.buildPackage {
          src = release-plz-src;
          pname = "release-plz-cli";
          cargoExtraArgs = "-p release-plz-cli";
          toolchain = rustToolchain;
        };

        # Build our own crate
        my-crate-src = pkgs.lib.cleanSource ./.;
        my-crate-cargo-artifacts = craneLib.buildDepsOnly {
          src = my-crate-src;
          toolchain = rustToolchain;
        };
        my-crate = craneLib.buildPackage {
          src = my-crate-src;
          cargoArtifacts = my-crate-cargo-artifacts;
          toolchain = rustToolchain;
        };

        # Python environment for Sphinx docs
        sphinxEnv = pkgs.python3.withPackages (ps: with ps; [
          sphinx
          sphinx-rtd-theme
          sphinxcontrib-rust
          sphinx-multiversion
          myst-parser
        ]);

      in
      {
        packages = {
          default = my-crate;
          release-plz-cli = release-plz-cli;
        };

        checks = {
          # Run tests with `nix flake check`
          default = craneLib.checkPackage {
            src = my-crate-src;
            cargoArtifacts = my-crate-cargo-artifacts;
            toolchain = rustToolchain;
          };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              # Rust
              rustToolchain
              pkgs.cargo
              pkgs.grcov
              pkgs.llvmPackages.llvm

              # Docs
              sphinxEnv
              pkgs.git

              # Releases
              release-plz-cli
            ];

            # Environment variables for coverage
            RUSTFLAGS = "-C instrument-coverage";
            LLVM_PROFILE_FILE = "target/coverage/cargo-test-%p-%m.profraw";
            CARGO_INCREMENTAL = "0";
          };
        };

        apps = {
          # Generate and view code coverage
          coverage = {
            type = "app";
            program = pkgs.writeShellScript "coverage-app" ''
              set -e
              echo "--- Running tests ---"
              cargo test

              echo "--- Generating coverage report ---"
              grcov . --binary-path ./target/debug/deps/ -s . -t html --branch --ignore-not-existing -o ./target/coverage/html
              grcov . --binary-path ./target/debug/deps/ -s . -t lcov --branch --ignore-not-existing -o ./target/coverage/tests.lcov

              echo "--- Coverage report generated in ./target/coverage/ ---"
              echo "--- You can view the HTML report at ./target/coverage/html/index.html ---"
            '';
          };

          # Build and serve versioned Sphinx documentation
          docs = {
            type = "app";
            program = pkgs.writeShellScript "docs-app" ''
              set -e
              echo "--- Building versioned Sphinx documentation ---"
              sphinx-multiversion docs/source docs/build/html
              echo "--- Docs built in ./docs/build/html ---"
            '';
          };

          serve-docs = {
            type = "app";
            program = pkgs.writeShellScript "serve-docs-app" ''
              set -e
              echo "--- Building versioned Sphinx documentation ---"
              sphinx-multiversion docs/source docs/build/html
              echo "--- Docs built in ./docs/build/html ---"
              echo "--- Starting web server at http://localhost:8000 ---"
              ${pkgs.python3}/bin/python -m http.server --directory docs/build/html 8000
            '';
          };
        };
      });
}
