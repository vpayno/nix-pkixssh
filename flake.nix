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

          devShells = {
            default = pkgs.mkShell {
              name = "pkixssh-dev-shell.${system}";
              packages = with pkgs; [
                bashInteractive
                binutils
                coreutils
                gawk
                git
                gnugrep
                gnused
                moreutils
              ];
              env = {
              };
              shellHook = ''
                ${pkgs.lib.getExe pkgs.cowsay} "Welcome to ${self'.devShells.default.name}"
                printf "\n"
              '';
            };
          };
        };

      # old legacy flake (migrate to modules and perSystem)
      # also for nixosConfiguration, darwinConfigurations, etc
      flake = {
      };
    };
}
