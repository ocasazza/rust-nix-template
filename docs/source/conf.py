# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'my-crate'
copyright = '2024, Your Name'
author = 'Your Name'
release = '0.1.0'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx_multiversion",
    # "sphinxcontrib_rust",  # Temporarily commented out for testing
    "myst_parser",
]

templates_path = ['_templates']
exclude_patterns = []

source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_sidebars = {
    '**': [
        'versioning.html',
    ],
}

# -- Options for sphinx-multiversion -----------------------------------------
smv_tag_whitelist = r'^v.*$'
smv_branch_whitelist = r'^main$'
smv_remote_whitelist = r'^(origin|upstream)$'
smv_released_pattern = r'^refs/tags/v.*$'
smv_outputdir_format = '{ref.name}'

# -- Options for sphinxcontrib-rust ------------------------------------------
rust_crates = {
    "my_crate": "../../",
}
rust_doc_dir = "../crates/"
rust_rustdoc_fmt = "md"

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
