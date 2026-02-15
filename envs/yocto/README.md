# Yocto

Build environment for the [Yocto Project](https://www.yoctoproject.org/).

## Overriding GCC and Python versions

Older Yocto releases may require older GCC and Python versions.
GCC 14 introduces stricter type checking that breaks builds of e.g. Kirkstone
and Dunfell, and recent Python versions removed modules like `asyncore` that
older bitbake relies on.

The environment uses `callPackage`, so `stdenv` and `python3` can be overridden
via `.override`:

### Flake

```nix
{
  inputs.nix-environments.url = "github:nix-community/nix-environments";

  outputs = { self, nixpkgs, nix-environments }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default =
      nix-environments.devShells.${system}.yocto.override {
        stdenv = pkgs.gcc11Stdenv;
        python3 = pkgs.python311;
      };
  };
}
```

### Tested configurations

| Yocto release | `stdenv`        | `python3`       |
|---------------|-----------------|-----------------|
| Kirkstone     | `gcc11Stdenv`   | `python311`     |
| Scarthgap     | `gcc11Stdenv`   | `python312`     |
| Latest        | default         | default         |
