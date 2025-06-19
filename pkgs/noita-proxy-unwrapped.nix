{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  python3,
  xorg,
  pkgs,
}:
rustPlatform.buildRustPackage rec {
  pname = "noita-proxy-unwrapped";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = "noita_entangled_worlds";
    tag = "v${version}";
    hash = "sha256-9TTgjfCPvM8K5BIN+gaMih7y80TaGbIOk2ThFxpfunk=";
  };

  sourceRoot = "${src.name}/noita-proxy";
  cargoLock.lockFile = "${src}/noita-proxy/Cargo.lock";

  useFetchCargoVendor = true;
  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    python3
    xorg.libxcb
    pkgs.pkg-config
    pkgs.cmake
  ];
  buildInputs = [
    pkgs.openssl

    pkgs.jack2
    pkgs.alsa-lib
    pkgs.libopus

    pkgs.xorg.libxcb
    pkgs.libxkbcommon
    pkgs.libGL

    # WINIT_UNIX_BACKEND=wayland
    pkgs.wayland

    # WINIT_UNIX_BACKEND=x11
    pkgs.xorg.libXcursor
    pkgs.xorg.libXrandr
    pkgs.xorg.libXi
    pkgs.xorg.libX11
  ];
  doCheck = false;

  meta = {
    description = "Noita multiplayer mod for entangled worlds";
    homepage = "https://github.com/IntQuant/noita_entangled_worlds";
    license = lib.licenses.mit; # Update this based on the actual license
    maintainers = [ ];
  };
}
