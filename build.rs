fn main() {
    println!(r"cargo:rustc-link-search=gambatte/libgambatte");
    println!(r"cargo:rustc-flags=-l dylib=stdc++");
    println!(r"cargo:rustc-flags=-l z");
}
