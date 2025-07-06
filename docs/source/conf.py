# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import toml
from pathlib import Path

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

# Read project info from Cargo.toml
cargo_toml_path = Path(__file__).parent.parent.parent / "Cargo.toml"
cargo_data = toml.load(cargo_toml_path)

project = cargo_data["package"]["name"]

# Extract author information from Cargo.toml
authors_list = cargo_data["package"].get("authors", ["Unknown"])
# Take the first author and extract just the name part (before email if present)
first_author = authors_list[0]
if "<" in first_author:
    author_name = first_author.split("<")[0].strip()
else:
    author_name = first_author.strip()

# Generate copyright with current year (2025)
copyright = f'2025, {author_name}'
author = author_name
release = cargo_data["package"]["version"]

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "myst_parser",
    "sphinxcontrib_rust",  # Temporarily commented out for testing
    "sphinx_multiversion",
]

exclude_patterns = []

source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

# -- Options for sphinxcontrib-rust ------------------------------------------
# https://sphinxcontrib-rust.readthedocs.io/en/stable/#

# rust_crates = {
#     "my_crate": ".",
#     "my_crate_derive": "my-crate-derive",
# }
# rust_doc_dir = "docs/crates/"
# rust_rustdoc_fmt = "rst"

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
# html_theme = 'sphinx_rtd_theme'

# -- Options for sphinx-multiversion -----------------------------------------
templates_path = [
    "_templates",
]

html_sidebars = {
    '**': [
        'versioning.html',
    ],
}
# Whitelist pattern for tags (set to None to ignore all tags)
smv_tag_whitelist = r'^.*$'
# Whitelist pattern for branches (set to None to ignore all branches)
smv_branch_whitelist = r'^.*$'
# Whitelist pattern for remotes (set to None to use local branches only)
smv_remote_whitelist = None
# Pattern for released versions
smv_released_pattern = r'^tags/.*$'
# Format for versioned output directories inside the build directory
smv_outputdir_format = '{ref.name}'
# Determines whether remote or local git branches/tags are preferred if their output dirs conflict
smv_prefer_remote_refs = True

# -- Options for myst-parser -------------------------------------------------
myst_enable_extensions = {
    "attrs_block",
    "colon_fence",
    "html_admonition",
    "replacements",
    "smartquotes",
    "strikethrough",
    "tasklist",
}
