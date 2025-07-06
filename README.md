# Rust Nix Template

This is a comprehensive template for Rust projects that provides a fully reproducible development environment using Nix, versioned documentation with Sphinx, and complete automation for releases, documentation deployment, and dependency management.

## ✨ Features

- **🔄 Reproducible Builds**: A Nix flake (`flake.nix`) provides a consistent development environment for all contributors
- **📊 Code Coverage**: Integrated code coverage reporting using `grcov` with HTML and LCOV output
- **📚 Versioned Documentation**: Professional, versioned documentation powered by Sphinx, `sphinxcontrib-rust`, and `sphinx-multiversion`
- **🚀 Automated Releases**: Complete semantic versioning with `release-plz` - patch releases on commits, minor on PRs, manual major releases
- **🌐 GitHub Pages**: Automatic documentation and coverage deployment to GitHub Pages on releases
- **🤖 Dependency Management**: Automated dependency updates via Dependabot with proper conventional commit formatting
- **⚡ CI/CD**: Comprehensive GitHub Actions workflows for testing, coverage, documentation, and releases
- **🔧 Development Tools**: Pre-configured development environment with all necessary tools

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

## 🤖 Automation Features

This template provides comprehensive automation for the entire development lifecycle.

### 🚀 Semantic Versioning & Releases

**Release Strategy**:
- **Patch releases** (e.g., 0.1.0 → 0.1.1): Automatic on every commit to `main`
- **Minor releases** (e.g., 0.1.0 → 0.2.0): Triggered by conventional commits (e.g., `feat:`)
- **Major releases** (e.g., 0.1.0 → 1.0.0): Triggered by breaking change commits (e.g., `feat!:`)

**Setup**:
1. **Add Repository Secrets**:
   - `CARGO_REGISTRY_TOKEN`: Your API token from `crates.io` for publishing

**How It Works**:
1. Push commits to `main` → `release-plz` analyzes changes and creates direct releases
2. Auto-generated CHANGELOG.md updated with conventional commit categorization
3. Package automatically published to crates.io + GitHub Release created
4. GitHub Release triggers documentation deployment

### 📚 Documentation Deployment

**Automatic deployment to GitHub Pages**:
- Triggered on every GitHub release
- Includes versioned documentation (sphinx-multiversion)
- Includes coverage reports
- Available at: `https://your-username.github.io/your-repo-name/`

**Setup**:
1. Go to Settings → Pages → Source → GitHub Actions
2. Documentation will be automatically deployed on first release

### 🔄 Dependency Management

**Dependabot Configuration**:
- **Rust dependencies**: Weekly updates on Mondays
- **GitHub Actions**: Weekly updates on Mondays
- **Python dependencies**: Weekly updates on Mondays
- All updates use conventional commit format for proper versioning

### ⚡ CI/CD Workflows

**On every PR and push**:
- **Nix Flake Check**: Validates the entire Nix environment
- **Coverage Generation**: Creates HTML and LCOV reports
- **Documentation Build**: Validates documentation builds successfully
- **PR Comments**: Automatic comments with artifact links

**On releases**:
- **Documentation Deployment**: Updates GitHub Pages
- **Release Comments**: Adds deployment links to GitHub releases

### 🔧 Conventional Commits & Auto-Generated Changelog

This template uses [Conventional Commits](https://www.conventionalcommits.org/) for automatic versioning and changelog generation:

```bash
# Patch release (bug fixes)
git commit -m "fix: resolve memory leak in parser"

# Minor release (new features)
git commit -m "feat: add new configuration option"

# Major release (breaking changes)
git commit -m "feat!: redesign API interface"

# Documentation (no version bump)
git commit -m "docs: update installation guide"

# Chores (no version bump)
git commit -m "chore: update dependencies"
```

**Auto-Generated CHANGELOG.md**:
- Automatically created and updated by `release-plz` on each release
- Groups commits by type with emoji categories:
  - 🚀 Features (`feat:`)
  - 🐛 Bug Fixes (`fix:`)
  - 📚 Documentation (`docs:`)
  - ⚡ Performance (`perf:`)
  - ♻️ Refactor (`refactor:`)
  - 🧪 Testing (`test:`)
  - 👷 CI/CD (`ci:`)
  - 🔧 Miscellaneous (`chore:`)
- Includes links to commits and GitHub issues/PRs
- Follows [Keep a Changelog](https://keepachangelog.com/) format
- Automatically handles version links and dates

### 📊 Coverage & Quality

**Automatic coverage reporting**:
- Generated on every CI run
- HTML reports uploaded as artifacts
- Deployed to GitHub Pages at `/coverage/`
- No CI failures on coverage thresholds (configurable)

**Code quality checks**:
- Rust formatting (`cargo fmt`)
- Linting (`cargo clippy`)
- Security audits (`cargo audit`)
- Dependency licensing (`cargo deny`)
- API compatibility (`cargo semver-checks`)

## 🛠️ Available Nix Apps

This template provides several convenient Nix apps:

```bash
# Build the project
nix build

# Run the project
nix run

# Generate coverage reports
nix run .#coverage

# Build documentation
nix run .#docs

# Build and serve documentation locally
nix run .#serve-docs
```

## 🔧 Customization

### Modifying Release Behavior

Edit `release-plz.toml` to customize:
- Release frequency (`release_always`)
- Changelog format
- PR and release templates
- Publishing settings

### Adding Dependencies

**Rust dependencies**: Add to `Cargo.toml` as usual
**Python dependencies**: Add to `requirements.txt`
**Nix dependencies**: Add to `flake.nix` packages list

### Cargo.lock Management

This template includes `Cargo.lock` in version control (not in `.gitignore`). This is recommended for:
- **Applications**: Always commit `Cargo.lock` for reproducible builds
- **Libraries**: You may choose to add `Cargo.lock` to `.gitignore` if you prefer

The current setup works for both use cases and ensures release-plz functions correctly.

### Automated Version Management

This template eliminates the need for manual version updates across files:

**✅ Automatically Updated**:
- `Cargo.toml` version → Updated by release-plz
- Documentation version → Dynamically read from `Cargo.toml`
- Built documentation → Inherits version from Sphinx config
- GitHub releases → Tagged with correct version
- CHANGELOG.md → Generated with version headers

**🚫 No Manual Updates Required**:
- No hardcoded version numbers in documentation
- No need to update multiple files for each release
- Version consistency guaranteed across all components

**How It Works**:
1. `release-plz` updates `Cargo.toml` version based on conventional commits
2. `docs/source/conf.py` reads version from `Cargo.toml` using Python `toml` library
3. Sphinx builds documentation with correct version automatically
4. All other components inherit or reference the single source of truth

### Documentation Customization

- **Sphinx config**: Edit `docs/source/conf.py`
- **Documentation content**: Add `.rst` or `.md` files to `docs/source/`
- **Themes and styling**: Modify Sphinx configuration

## 🐛 Troubleshooting

### Common Issues

**"sphinxcontrib-rust build fails"**:
- Ensure you're in the Nix development shell
- The virtual environment setup handles Rust toolchain conflicts automatically

**"Documentation not building"**:
- Ensure you have at least one Git tag: `git tag v0.1.0`
- Check that your Rust code has proper doc comments

**"Release-plz not creating releases"**:
- Verify GitHub Actions permissions are configured
- Check that `CARGO_REGISTRY_TOKEN` secret is set
- Ensure commits follow conventional commit format

**"Coverage reports empty"**:
- Make sure you have tests in your project
- Verify the `RUSTFLAGS` environment variable is set correctly

### Getting Help

- **Nix Issues**: [Nix Manual](https://nixos.org/manual/nix/stable/)
- **Release-plz**: [Release-plz Documentation](https://release-plz.dev/)
- **Sphinx**: [Sphinx Documentation](https://www.sphinx-doc.org/)
- **Conventional Commits**: [Conventional Commits Specification](https://www.conventionalcommits.org/)

## 📄 License

This template is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Make sure to follow the conventional commit format for proper versioning.

---

**Happy coding! 🦀✨**
