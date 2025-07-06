use rust_nix_template::{greet, add, factorial};

fn main() {
    println!("🦀 Welcome to the Rust Nix Template!");
    println!();

    // Demonstrate the library functions
    println!("📚 Library Examples:");
    println!("  {}", greet("Rust Developer"));
    println!("  2 + 3 = {}", add(2, 3));
    println!("  5! = {}", factorial(5));
    println!();

    println!("✨ Features:");
    println!("  🔄 Reproducible builds with Nix");
    println!("  🚀 Automated releases with semantic versioning");
    println!("  📊 Code coverage reporting");
    println!("  📚 Professional documentation with Sphinx");
    println!("  🌐 GitHub Pages deployment");
    println!("  🤖 Automated dependency management");
    println!();

    println!("🛠️  Try these commands:");
    println!("  nix run .#coverage    # Generate coverage reports");
    println!("  nix run .#docs        # Build documentation");
    println!("  nix run .#serve-docs  # Serve docs locally");
    println!();

    println!("Happy coding! 🎉");
}
