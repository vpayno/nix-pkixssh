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
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
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
              name = "pkixssh-client-dev-shell.${system}";
              packages =
                with pkgs;
                [
                  bashInteractive
                  binutils
                  coreutils
                  gawk
                  git
                  glow
                  gnugrep
                  gnused
                  moreutils
                  runme
                ]
                ++ (with self'.packages; [
                  pkixssh-client
                  pkixssh-client.man
                ]);
              env = {
              };
              shellHook = ''
                ${pkgs.lib.getExe pkgs.cowsay} "Welcome to ${self'.devShells.default.name}"
                printf "\n"
              '';
            };
          };

          packages = {
            pkixssh-client = pkgs.stdenv.mkDerivation (finalAttrs: rec {
              pname = "pkixssh-client";
              version = "17.2.2";
              name = "${self'.packages.pkixssh-client.pname}-${self'.packages.pkixssh-client.version}";
              meta = {
                homepage = "https://gitlab.com/secsh/pkixssh";
                description = "PKIX-SSH - an advanced secure shell implementation";
                changelog = "https://gitlab.com/secsh/pkixssh/-/tags";
                licenses = with pkgs.lib.licenses; [
                  bsd2
                  {
                    deprecated = false;
                    free = true;
                    fullName = "Tatu Ylonen License";
                    redistributable = true;
                    shortName = "tatu";
                    url = "https://gitlab.com/secsh/pkixssh/-/blob/master/LICENCE?ref_type=heads";
                  }
                ];
                inherit (pkgs.openssh.meta) platforms;
                mainProgram = "ssh";
              };
              src = pkgs.fetchgit {
                url = "https://gitlab.com/secsh/pkixssh";
                rev = "fa4106aaa5fba8528b95a8d6339d276e16ce03d2"; # v17.2.2
                fetchSubmodules = false;
                deepClone = false;
                leaveDotGit = false;
                sha256 = "sha256-oSTabO75NNAoyrvmtcaU9cwtoJni/nerGnz8/KFUZN4=";
              };
              nativeBuildInputs = with pkgs; [
                autoconf
                automake
                tree
              ];
              buildInputs = with pkgs; [
                openssl
                openssl.dev
                zlib
                zlib.dev
              ];
              enableParallelBuilding = true;
              outputs = [
                "out"
                "man"
              ];
              configureFlags = [
                "--prefix=$out"
                "--sysconfdir=$out/etc/ssh"
              ];
              configurePhase = ''
                autoreconf
                ./configure ${builtins.toString configureFlags}
              '';
              installPhase = ''
                mkdir -pv $out/{bin,etc/ssh}
                cp -vp ./contrib/ssh-copy-id ./contrib/ssh-askpass-zenity $out/bin/
                # cp -vp sftp-server sshd $out/bin/
                cp -vp scp sftp ssh ssh-add ssh-agent ssh-keygen ssh-keyscan ssh-keysign ssh-keysign ssh-pkcs11-helper $out/bin/
                # cp -v sshd_config $out/etc/ssh/
                cp -v ssh_config $out/etc/ssh/ssh_config.example

                mkdir -p $man/share/man/man{1,5,8}
                cp -v ./*[.]1 $man/share/man/man1/
                cp -v ./*[.]5 $man/share/man/man5/
                cp -v ./*[.]8 $man/share/man/man8/
                rm -fv $man/share/man/man*/sshd* $man/share/man/man*/sftp-server*

                tree $out $man
              '';
            });
          };
        };

      # old legacy flake (migrate to modules and perSystem)
      # also for nixosConfiguration, darwinConfigurations, etc
      flake = {
      };
    };
}
