{ buildGoModule, fetchFromGitHub, pandoc, lib }:

buildGoModule rec {
  pname = "checkmake";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mrtazz";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ql8XSQA/w7wT9GbmYOM2vG15GVqj9LxOGIu8Wqp9Wao=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ pandoc ];

  preBuild =
    let
      buildVars = {
        version = version;
        buildTime = "N/A";
        builder = "nix";
        goversion = "$(go version | egrep -o 'go[0-9]+[.][^ ]*')";
      };
      buildVarsFlags = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "-X main.${k}=${v}") buildVars);
    in
    ''
      buildFlagsArray+=("-ldflags=${buildVarsFlags}")
    '';

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    pandoc -s -t man -o $out/share/man/man1/checkmake.1 man/man1/checkmake.1.md
  '';

  meta = with lib; {
    description = "Experimental tool for linting and checking Makefiles";
    homepage = "https://github.com/mrtazz/checkmake";
    license = licenses.mit;
    maintainers = with maintainers; [ vidbina ];
    longDescription = ''
      checkmake is an experimental tool for linting and checking
      Makefiles. It may not do what you want it to.
    '';
  };
}
