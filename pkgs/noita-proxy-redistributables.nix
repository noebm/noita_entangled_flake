{
  lib,
  stdenv,
  version,
  src,
}:

stdenv.mkDerivation {
  pname = "noita-proxy-redistributables";
  inherit version src;

  installPhase = ''
    mkdir -p $out/lib $out/share
    cp redist/*.so $out/lib/
    cp redist/*.md $out/share/
  '';

  dontBuild = true;
  meta = {
    description = "Noita multiplayer mod for entangled worlds (redistributables)";
    license = with lib.licenses; [ unfree ];
  };
}
