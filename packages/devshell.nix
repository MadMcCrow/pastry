# ppackages/devshell.nix
# flake-parts module to add a devshell for building packages
{
  config,
  lib,
  ...
}: {
  options.pastry.packages = {
    devshell = lib.mkEnableOption "add a shell from packages" // {
      default = true;
    };
  config = lib.mkIf config.pastry.packages.devshell {
  perSystem =
    args@{
      pkgs,
      lib,
      ...
    }:
    {
      # TODO
    };
  };
}
