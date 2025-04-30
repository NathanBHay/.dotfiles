{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  jq,
}:
stdenv.mkDerivation rec {
  pname = "chuffed";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "chuffed";
    repo = "chuffed";
    rev = "stable";
    hash = "sha256-D4HEcCDcJi05AL9suc7Twtf/wjpwBkLEeumGY3nNi5g=";
  };

  nativeBuildInputs = [
    cmake
    jq
  ];

  configurePhase = ''
    cmake -B build -S . -DCMAKE_INSTALL_PREFIX=$out
  '';

  buildPhase = ''
    cmake --build build
  '';

  installPhase = ''
    cmake --build build --target install
  '';

  postInstall = ''
    jq \
    '.version = "${version}"
     | .mznlib = "${out}/share/chuffed/mznlib"
     | .executable = "${out}/bin/fzn-chuffed"' \
     ${./chuffed.msc} \
     >$out/share/minizinc/solvers/chuffed.msc
  '';

  # doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/chuffed/chuffed";
    description = "The Chuffed CP solver";
    license = licenses.mit;
    platforms = platforms.x86_64;
  };
}
