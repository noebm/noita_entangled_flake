{ pkgs }:

let
  noita-proxy-unwrapped = pkgs.callPackage ./noita-proxy-unwrapped.nix { };
  noita-proxy = pkgs.callPackage ./noita-proxy.nix { inherit noita-proxy-unwrapped; };
in

{
  inherit noita-proxy-unwrapped noita-proxy;
}
