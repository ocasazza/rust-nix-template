//! # My Crate
//!
//! This is a sample crate to demonstrate the features of the rust-nix-template.

/// Adds two to the given number.
///
/// # Examples
///
/// ```
/// let arg = 5;
/// let answer = my_crate::add_two(arg);
///
/// assert_eq!(7, answer);
/// ```
pub fn add_two(x: i32) -> i32 {
    x + 2
}

fn main() {
    let result = add_two(2);
    println!("2 + 2 = {}", result);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(add_two(2), 4);
    }
}
