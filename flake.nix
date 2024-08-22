{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.easyOverlay
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          overlays = [
            inputs.self.overlays.default
          ];
          inherit system;
        };
        overlayAttrs = config.packages;
        packages = {
          nbxplorer = pkgs.callPackage ./packages/nbxplorer {};
          nbitcoin = pkgs.callPackage ./packages/nbitcoin {};
        };
      };
      flake = {
      };
    };
}
