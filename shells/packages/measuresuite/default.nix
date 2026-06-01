{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config }:
stdenv.mkDerivation rec {
  pname = "assemblyline";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "0xADE1A1DE";
    repo = "MeasureSuite";
    rev = "v${version}";
    hash = "sha256-Et22KHDNmw/7MK7WFsm+H4eHncJWBn53czufgTexa+M=";
  };

  nativeBuildInputs = [ ];

  # doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/0xADE1A1DE/AssemblyLine";
    description =
      "A C library and binary for generating machine code of x86_64 assembly language and executing on the fly without invoking another compiler, assembler or linker.";
    license = licenses.asl20;
    platforms = platforms.x86_64;
  };
}
