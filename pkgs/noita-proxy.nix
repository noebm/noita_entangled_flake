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
  pname = "noita-proxy";
  version = "0.30.8";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = "noita_entangled_worlds";
    rev = "ba7a561ffd4ccf3e4dce8939de782c6fb5ebcafe";
    hash = "sha256-rTO0/eWTJDp1j8Non4tB1CnzzycqcLE1qBdUteJdhcA=";
  };

  sourceRoot = "${src.name}/noita-proxy";

  cargoHash = "sha256-D+TTIwx0N7yx/AK19r/KFO43u2DsggJe9SJs5DMzVbg=";
  useFetchCargoVendor = true;
  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    python3
    xorg.libxcb
  ];
  buildInputs = [
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

  # buildPhase = ''
  # cargo build -j 16 --profile=dev
  # '';
  # cargoLock.lockFile = "${programSrc}/noita-proxy/Cargo.lock";
  # cargoLock.outputHashes = {
  #   "steamworks-0.11.0" = "sha256-brAAzwJQpefWJWCveHqBLvrlAi0tUn07V/XkWXCj8PE=";
  # };

  meta = {
    description = "Noita multiplayer mod for entangled worlds";
    homepage = "https://github.com/IntQuant/noita_entangled_worlds";
    license = lib.licenses.mit; # Update this based on the actual license
    maintainers = [ ];
  };
}
