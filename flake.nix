{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      my-packages = import ./pkgs { inherit pkgs; };
    in
    {
      packages.${system} = rec {
        inherit (my-packages) noita-proxy-unwrapped noita-proxy-redistributables noita-proxy;
        default = noita-proxy;
      };
    };

}
