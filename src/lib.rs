//! # Rust Nix Template Library
//!
//! This is a comprehensive template for Rust projects that provides a fully reproducible
//! development environment using Nix, versioned documentation with Sphinx, and complete
//! automation for releases, documentation deployment, and dependency management.
//!
//! ## Features
//!
//! - Reproducible builds with Nix
//! - Automated releases with semantic versioning
//! - Professional documentation with Sphinx
//! - Code coverage reporting
//! - Comprehensive CI/CD pipeline
//!
//! ## Example
//!
//! ```rust
//! use rust_nix_template::greet;
//!
//! let message = greet("World");
//! assert_eq!(message, "Hello, World!");
//! ```

/// Greets someone with a friendly message.
///
/// # Arguments
///
/// * `name` - The name of the person to greet
///
/// # Returns
///
/// A greeting message as a String
///
/// # Examples
///
/// ```
/// use rust_nix_template::greet;
///
/// let message = greet("Alice");
/// assert_eq!(message, "Hello, Alice!");
/// ```
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

/// Adds two numbers together.
///
/// This is a simple utility function that demonstrates basic arithmetic
/// and serves as an example for documentation and testing.
///
/// # Arguments
///
/// * `a` - The first number
/// * `b` - The second number
///
/// # Returns
///
/// The sum of `a` and `b`
///
/// # Examples
///
/// ```
/// use rust_nix_template::add;
///
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Calculates the factorial of a number.
///
/// # Arguments
///
/// * `n` - A non-negative integer
///
/// # Returns
///
/// The factorial of `n`
///
/// # Panics
///
/// Panics if `n` is negative.
///
/// # Examples
///
/// ```
/// use rust_nix_template::factorial;
///
/// assert_eq!(factorial(0), 1);
/// assert_eq!(factorial(5), 120);
/// ```
pub fn factorial(n: u32) -> u32 {
    match n {
        0 | 1 => 1,
        _ => n * factorial(n - 1),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_greet() {
        assert_eq!(greet("World"), "Hello, World!");
        assert_eq!(greet("Rust"), "Hello, Rust!");
        assert_eq!(greet(""), "Hello, !");
    }

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
        assert_eq!(add(-1, 1), 0);
        assert_eq!(add(0, 0), 0);
        assert_eq!(add(100, 200), 300);
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(2), 2);
        assert_eq!(factorial(3), 6);
        assert_eq!(factorial(4), 24);
        assert_eq!(factorial(5), 120);
    }

    #[test]
    fn test_factorial_larger_numbers() {
        assert_eq!(factorial(6), 720);
        assert_eq!(factorial(7), 5040);
    }
}
