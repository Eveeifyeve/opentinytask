{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          lib,
          pkgs,
          system,
          config,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import inputs.rust-overlay)
            ];
          };

          packages.default = pkgs.callPackage ./package.nix { };

          devShells.default =
            with pkgs;
            let
              toolchain = pkgs.rust-bin.stable.latest.default.override {
                extensions = [ "rust-src" ];
                targets = [ "x86_64-unknown-linux-gnu" ];
              };
            in
            mkShell {
              nativeBuildInputs =
                with pkgs;
                [
                  toolchain
                  bun
                ]
                ++ lib.optionals stdenv.isLinux [ openssl ]
                ++ lib.optionals stdenv.isDarwin [ apple-sdk ];
            };
        };
    };
}
