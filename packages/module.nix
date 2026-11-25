# packages/modules.nix
# flake-part module to help adding packages
{ inputs, ... }: {
  flake.flakeModules.packages =
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
        enable = lib.mkEnableOption "help add packages" // {
          default = true;
        };
        paths = lib.mkOption {
          description = "list of path of packages to expose as outputs";
          type = with lib.types; listOf path;
          default = [ ];
        };
        args = lib.mkOption {
          description = "extra args to pass to the `callPackage` for each paths in `pastry.packages.paths`";
          type = lib.types.attrs;
          default = { };
        };
      };
      config = lib.mkIf cfg.enable {
        perSystem =
          args@{
            pkgs,
            lib,
            ...
          }:
          let
            pkgslib = import ./_lib.nix args;
          in
          {
            # expose our lib
            lib = pkgslib;
            # add the packages paths
            packages = pkgslib.genPkgs {
              inherit (cfg) paths args;
            };
          };
      };
    };
}
