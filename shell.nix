let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { overlays = [ (import sources.nixpkgs-mozilla) ]; };
  dhallpkgs = import sources.easy-dhall-nix { inherit pkgs; };
  dhall-yaml = dhallpkgs.dhall-yaml-simple;
  dhall = dhallpkgs.dhall-simple;
  rust = pkgs.callPackage ./nix/rust.nix { };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    # Rust
    rust
    cargo-make
    diesel-cli
    cargo-watch

    # Dhall
    dhall
    dhall-yaml

    # Dependecy manager
    niv
  ];

  RUST_SRC_PATH = "${pkgs.latest.rustChannels.nightly.rust-src}/lib/rustlib/src/rust/library";
  RUST_BACKTRACE = "1";
}
