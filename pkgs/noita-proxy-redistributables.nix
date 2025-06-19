{
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "noita-proxy-redistributables";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = "noita_entangled_worlds";
    tag = "v${version}";
    hash = "sha256-9TTgjfCPvM8K5BIN+gaMih7y80TaGbIOk2ThFxpfunk=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp redist/libsteam_api.so $out/lib/
  '';

  dontBuild = true;
}
