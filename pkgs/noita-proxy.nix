{
  lib,
  stdenv,
  makeWrapper,
  noita-proxy-unwrapped,
  # library dependencies
  xorg,
  libxkbcommon,
  libGL,
  wayland,
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

            libxkbcommon
            libGL

            wayland

            xorg.libxcb
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libX11

            noita-proxy-redistributables
          ]
        }"
  '';

  meta = noita-proxy-unwrapped.meta // {
    description = "Noita multiplayer mod for entangled worlds (wrapper)";
    licence = noita-proxy-unwrapped.meta.licence + noita-proxy-redistributables.meta.licence;
  };
}
