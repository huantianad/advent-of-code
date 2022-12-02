{
  description = "test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nimble.url = "github:nix-community/flake-nimble";
    nimble.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs, nimble }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ nimble.overlay ]; };
      in
      rec {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; with pkgs.nimPackages; [
            openssl_1_1
            openssl
            nim
            jsony
            print
            nimquery
            benchy
          ];
        };
      }
    );
}
