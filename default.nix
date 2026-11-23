# default.nix
# give the flake outputs, without needing flakes enabled
{
  pkgs ? import <nixpkgs> { },
}:
(import ./compat.nix).outputs
