{
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "noita-proxy-redistributables";
  version = "ba7a561";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = "noita_entangled_worlds";
    rev = "ba7a561ffd4ccf3e4dce8939de782c6fb5ebcafe";
    hash = "sha256-rTO0/eWTJDp1j8Non4tB1CnzzycqcLE1qBdUteJdhcA=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp redist/libsteam_api.so $out/lib/
  '';

  dontBuild = true;
}
