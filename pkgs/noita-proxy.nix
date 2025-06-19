{
  lib,
  stdenv,
  makeWrapper,
  steam,
  wayland,
  xorg,
  libGL,
  libxkbcommon,
  noita-proxy-unwrapped,
  noita-proxy-redistributables,
}:

stdenv.mkDerivation {
  pname = "noita-proxy";
  version = noita-proxy-unwrapped.version;

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    makeWrapper ${noita-proxy-unwrapped}/bin/noita-proxy $out/bin/noita-proxy \
        --set LD_LIBRARY_PATH "${
          lib.makeLibraryPath [
            wayland

            libGL
            libxkbcommon
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libX11
            xorg.libxcb

            noita-proxy-redistributables
          ]
        }"
  '';

  meta = noita-proxy-unwrapped.meta // {
    description = "Noita multiplayer mod for entangled worlds (with Steam wrapper)";
  };
}
