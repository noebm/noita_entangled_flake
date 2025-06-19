{ pkgs }:

let
  version = "1.5.5";
  src = pkgs.fetchFromGitHub {
    owner = "IntQuant";
    repo = "noita_entangled_worlds";
    tag = "v${version}";
    hash = "sha256-9TTgjfCPvM8K5BIN+gaMih7y80TaGbIOk2ThFxpfunk=";
  };

  noita-proxy-unwrapped = pkgs.callPackage ./noita-proxy-unwrapped.nix {
    inherit version src;
  };
  noita-proxy-redistributables = pkgs.callPackage ./noita-proxy-redistributables.nix {
    inherit version src;
  };
  noita-proxy = pkgs.callPackage ./noita-proxy.nix {
    inherit noita-proxy-unwrapped noita-proxy-redistributables;
  };
in

{
  inherit noita-proxy-unwrapped noita-proxy-redistributables noita-proxy;
}
