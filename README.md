# nix-pkixssh

Flake for building and installing [pkixssh](https://gitlab.com/secsh/pkixssh).

## Roadmap

- `pkixssh-client` package
- add `overlays` flake output
- `pkixssh-server` package
- merge client/server packages
- add `nixosModule`
- add `home-manager` module

## pkixssh-client

First step to making the package.

### Installation

You can start an adhoc shell with the command:

```bash
nix shell github:vpayno/nix-pkixssh#pkixssh-client
```

You can manually install it to the current user's `PATH` using
`nix profile add`:

```bash { name=install-pkixssh-client }
nix profile add github:vpayno/nix-pkixssh#pkixssh-client
```

You can also use it in a devShell or a system using the path
`pkixssh.packages.${system}.pkixssh-client`:

```nix
{
	inputs = {
		pkixssh.url = "github:vpayno/nix-pkixssh";
	};

	outputs = {
		pkixssh
	}: {
		devShells.${system} = pkgs.mkShell {
			packages = [
				pkixssh.packages.${system}.pkixssh-client
			];
		};
	}
}
```
