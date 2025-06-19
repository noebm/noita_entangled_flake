{
  lib,
  version,
  src,
  rustPlatform,

  # native build dependencies
  python3,
  pkg-config,
  cmake,

  # build dependencies
  openssl,
  jack2,
  alsa-lib,
  libopus,
  xorg,
  libxkbcommon,
  libGL,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "noita-proxy-unwrapped";
  inherit version src;

  sourceRoot = "${src.name}/noita-proxy";
  cargoLock.lockFile = "${src}/noita-proxy/Cargo.lock";

  useFetchCargoVendor = true;
  nativeBuildInputs = [
    python3
    pkg-config
    cmake
  ];
  buildInputs = [
    openssl

    jack2
    alsa-lib
    libopus

    libxkbcommon
    libGL

    wayland

    xorg.libxcb
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];
  doCheck = false;

  meta = {
    description = "Noita multiplayer mod for entangled worlds";
    homepage = "https://github.com/IntQuant/noita_entangled_worlds";
    license = with lib.licenses; [
      asl20
      mit
    ];
  };
}
