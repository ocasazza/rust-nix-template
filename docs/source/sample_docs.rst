Sample Documentation
====================

This section provides sample documentation to demonstrate how to add new pages and content to your Sphinx project. We'll use examples from the `rust-nix-template` library.

About This Project
------------------

The `rust-nix-template` is designed to provide a robust and reproducible development environment for Rust projects. It integrates various tools and practices to streamline the development workflow.

*   **Reproducible Builds**: Achieved using Nix.
*   **Automated Releases**: Managed with `release-plz` for semantic versioning.
*   **Professional Documentation**: Powered by Sphinx.
*   **CI/CD**: Comprehensive GitHub Actions workflows.

Library Functions
-----------------

Here are some examples of functions available in the `rust-nix-template` library.

`greet` Function
^^^^^^^^^^^^^^^

The `greet` function returns a friendly greeting message.

.. code-block:: rust

    pub fn greet(name: &str) -> String {
        format!("Hello, {}!", name)
    }

**Example Usage:**

.. code-block:: rust

    use rust_nix_template::greet;

    let message = greet("World");
    assert_eq!(message, "Hello, World!");

`add` Function
^^^^^^^^^^^^^

The `add` function takes two integers and returns their sum.

.. code-block:: rust

    pub fn add(a: i32, b: i32) -> i32 {
        a + b
    }

**Example Usage:**

.. code-block:: rust

    use rust_nix_template::add;

    let result = add(2, 3);
    assert_eq!(result, 5);

`factorial` Function
^^^^^^^^^^^^^^^^^^^

The `factorial` function calculates the factorial of a non-negative integer.

.. code-block:: rust

    pub fn factorial(n: u32) -> u32 {
        match n {
            0 | 1 => 1,
            _ => n * factorial(n - 1),
        }
    }

**Example Usage:**

.. code-block:: rust

    use rust_nix_template::factorial;

    assert_eq!(factorial(0), 1);
    assert_eq!(factorial(5), 120);
