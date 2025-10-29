{
  description = "Flake for managing pkixssh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-conf.url = "github:vpayno/nix-treefmt-conf";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          formatter = inputs.treefmt-conf.formatter.${system};
        };

      # old legacy flake (migrate to modules and perSystem)
      # also for nixosConfiguration, darwinConfigurations, etc
      flake = {
      };
    };
}
