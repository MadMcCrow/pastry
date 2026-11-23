# shell.nix
# give the default dev-shell for systems without flakes
{
  pkgs ? import <nixpkgs> { },
}:
(import ./compat.nix).outputs;
