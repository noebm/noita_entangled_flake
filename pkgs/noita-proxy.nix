{
  lib,
  stdenv,
  makeWrapper,
  steam,
  noita-proxy-unwrapped,
}:

stdenv.mkDerivation {
  pname = "noita-proxy";
  version = noita-proxy-unwrapped.version;

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${noita-proxy-unwrapped}/bin/noita-proxy $out/bin/noita-proxy \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ steam ]}"
  '';

  meta = noita-proxy-unwrapped.meta // {
    description = "Noita multiplayer mod for entangled worlds (with Steam wrapper)";
  };
}
