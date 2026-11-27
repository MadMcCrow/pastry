# packages/devshell.nix
# flake-parts module to add a devshell for building packages
{
  config,
  lib,
  ...
}:
let
  cfg = config.pastry.packages;
in
{
  options.pastry.packages = {
    devShell = lib.mkEnableOption "add a shell from packages" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && cfg.devShell) {
    perSystem =
      args@{
        pkgs,
        lib,
        config,
        ...
      }:
      let
        # same packages as `perSystem.packages` in module.nix,
        # but only the ones from `paths` (not tests, etc.)
        pkgsFromPaths = config.lib.genPkgs {
          inherit (cfg) paths;
          args = if lib.isFunction cfg.specialArgs then cfg.specialArgs args else cfg.specialArgs;
        };
        devShell = pkgs.mkShell {
          inputsFrom = lib.attrValues pkgsFromPaths;
        };
      in
      {
        devShells = {
          dev = devShell;
          default = lib.mkDefault devShell;
        };
      };
  };
}
