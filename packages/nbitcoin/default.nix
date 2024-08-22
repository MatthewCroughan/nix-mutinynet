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

  prePatch = ''
    substituteInPlace NBitcoin/Bitcoin.cs --replace-fail \
      '512103ad5e0edad18cb1f0fc0d28a3d4f1f3e445640337489abb10404f2d1e086be430210359ef5021964fe22d6f8e05b2463c9540ce96883fe3b278760f048f5189f2e6c452ae' \
      '512102f7561d208dd9ae99bf497273e16f389bdbd6c4742ddb8e6b216e64fa2928ad8f51ae'
  '';

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
