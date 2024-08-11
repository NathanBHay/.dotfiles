{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config }:
stdenv.mkDerivation rec {
  pname = "assemblyline";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "0xADE1A1DE";
    repo = "AssemblyLine";
    rev = "v${version}";
    hash = "sha256-Et22KHDNmw/7MK7WFsm+H4eHncJWBn53czufgTexa+M=";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';

  # doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/0xADE1A1DE/AssemblyLine";
    description =
      "A C library and binary for generating machine code of x86_64 assembly language and executing on the fly without invoking another compiler, assembler or linker.";
    license = licenses.asl20;
    platforms = platforms.x86_64;
  };
}
