{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config }:
stdenv.mkDerivation rec {
  pname = "cryptopt";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "0xADE1A1DE";
    repo = "CryptOpt";
    rev = "v${version}";
    hash = "sha256-Et22KHDNmw/7MK7WFsm+H4eHncJWBn53czufgTexa+M=";
  };

  nativeBuildInputs = [ ];

  # doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/0xADE1A1DE/CryptOpt";
    description = "";
    license = licenses.asl20;
    platforms = platforms.x86_64;
  };
}
