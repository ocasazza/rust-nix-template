# Rust Nix Template

This is a comprehensive template for Rust projects that provides a fully reproducible development environment using Nix, versioned documentation with Sphinx, and automated releases with `release-plz`.

## Features

- **Reproducible Builds**: A Nix flake (`flake.nix`) provides a consistent development environment for all contributors.
- **Code Coverage**: Integrated code coverage reporting using `grcov`.
- **Versioned Documentation**: Professional, versioned documentation powered by Sphinx, `sphinxcontrib-rust`, and `sphinx-multiversion`.
- **Automated Releases**: `release-plz` and GitHub Actions work together to automate the entire release process, including changelog generation and publishing to `crates.io`.
- **CI/CD**: GitHub Actions workflows for continuous integration and automated releases.

## Prerequisites

1.  **Nix**: You must have Nix installed with flake support enabled. See the [official Nix documentation](https://nixos.org/download.html) for installation instructions.
2.  **Git**: Required for version control and for `sphinx-multiversion` to work correctly.

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```

2.  **Initialize Git**:
    This template relies on Git for versioning. Initialize a repository and make an initial commit.
    ```bash
    git init
    git add .
    git commit -m "Initial commit"
    ```

3.  **Enter the Development Shell**:
    Activate the Nix development environment. This will download all the required tools (Rust, Python, Sphinx, etc.).
    ```bash
    nix develop
    ```

## Development Workflow

All commands should be run from within the `nix develop` shell.

### Building the Project

You can build the Rust crate using standard Cargo commands or with Nix:

-   **With Cargo**:
    ```bash
    cargo build
    ```
-   **With Nix**:
    ```bash
    nix build
    ```
    The result will be in the `./result` directory.

### Running Tests

-   **With Cargo**:
    ```bash
    cargo test
    ```
-   **With Nix Flake Check**:
    ```bash
    nix flake check
    ```

### Code Coverage

To generate a code coverage report, run the `coverage` app defined in the flake:

```bash
nix run .#coverage
```

This will:
1.  Run your tests.
2.  Generate an `lcov` report at `target/coverage/tests.lcov` (for IDE integration).
3.  Generate an HTML report at `target/coverage/html/index.html`.

### Documentation

This template uses Sphinx to generate versioned documentation from your Rust docstrings.

1.  **Create a Git Tag**: `sphinx-multiversion` uses Git tags to identify versions. Create at least one tag.
    ```bash
    git tag -a v0.1.0 -m "Version 0.1.0"
    ```

2.  **Build and Serve the Docs**:
    Run the `serve-docs` app to build the documentation and serve it locally:
    ```bash
    nix run .#serve-docs
    ```
    You can then view your versioned documentation at `http://localhost:8000`.

## Automated Releases

This template is configured to automate releases using `release-plz`.

### Setup

1.  **Create a GitHub App**:
    For the best experience, create a GitHub App as described in the [`release-plz` documentation](https://release-plz.dev/docs/github/token#use-a-github-app). This allows the release PRs to trigger CI workflows.
    -   Give the app "Read & write" permissions for "Contents" and "Pull requests".
    -   Install the app on your repository.

2.  **Add Repository Secrets**:
    In your GitHub repository settings, go to `Secrets and variables > Actions` and add the following secrets:
    -   `APP_ID`: The ID of your GitHub App.
    -   `APP_PRIVATE_KEY`: The private key you generated for your GitHub App.
    -   `CARGO_REGISTRY_TOKEN`: Your API token from `crates.io` to allow publishing.

### How It Works

1.  When you push commits to the `main` branch, the `release-plz.yml` workflow runs.
2.  `release-plz` determines if a new release is needed based on your commit messages (it follows Conventional Commits).
3.  If a release is needed, it opens a "Release PR" containing the version bumps and an updated `CHANGELOG.md`.
4.  The `ci.yml` workflow runs on this PR, ensuring all checks pass.
5.  When you merge the Release PR, `release-plz` runs again, publishes the new version to `crates.io`, creates a GitHub Release, and tags the commit.
