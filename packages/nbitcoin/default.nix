{ lib
, fetchFromGitHub
, buildDotnetModule
}:

buildDotnetModule {
  pname = "nbitcoin";
  version = "7.0.34";

  projectFile = "NBitcoin/NBitcoin.csproj";

  src = fetchFromGitHub {
    owner = "MetacoSA";
    repo = "NBitcoin";
    rev = "v7.0.34";
    hash = "sha256-X7cqYuk8/Wh2YbP7lEs5Tyhii1NB/zn4oVCeR+yK6PQ=";
  };

  dotnetFlags = [
    "--property:TargetFramework=netstandard2.1"
    "--property:TargetFrameworks=netstandard2.1"
  ];

  preInstall = ''
    # the dierctory name differs based on architecture. I'm not sure if multiple
    # outputs can be produced
    cp /build/source/NBitcoin/bin/Release/netstandard2.1/linux-*/* /build/source/NBitcoin/bin/Release/netstandard2.1
  '';

  nugetDeps = ./deps.nix;

  packNupkg = true;

  meta = with lib; {
    description = "Comprehensive Bitcoin library for the .NET framework";
    homepage = "https://github.com/chrisguida/NBitcoin";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "nbitcoin";
    platforms = platforms.all;
  };
}
