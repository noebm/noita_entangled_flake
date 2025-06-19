{ pkgs }:

let
  noita-proxy-unwrapped = pkgs.callPackage ./noita-proxy-unwrapped.nix { };
  noita-proxy-redistributables = pkgs.callPackage ./noita-proxy-redistributables.nix { };
  noita-proxy = pkgs.callPackage ./noita-proxy.nix {
    inherit noita-proxy-unwrapped noita-proxy-redistributables;
  };
in

{
  inherit noita-proxy-unwrapped noita-proxy-redistributables noita-proxy;
}
