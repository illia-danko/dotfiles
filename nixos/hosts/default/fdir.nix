{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "fdir";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "illia-danko";
    repo = pname;
    rev = "master";
    sha256 = "mCXqNB40DML2/XG7URqNGcWGzXwA5J2hSBOPWwkTVa8=";
  };

  vendorHash = null;
  doCheck = false;

  meta = with lib; {
    description = "Dymmy search project folders";
    homepage = "https://github.com/illia-danko/${pname}";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
