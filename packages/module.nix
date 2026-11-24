# packages/modules.nix
# flake-part module to help adding packages
{ inputs, ... } :
{
flake = {
  flakeModules.packages =
    {
      config,
      lib,
      ...
    }:
    {
      options.pastry.packages = {
        enable = lib.mkEnableOption "help add packages" // { default = true; };
        packages = lib.mkOption {
          description = "list of packages to expose as outputs";
          types = with lib.types; listOf package;
          default = [];
        };
      };
      config = lib.mkIf config.pastry.packages.enable {
        perSystem =
          args@{
            pkgs,
            lib,
            ...
          }:
          let
            pkgslib = import ./lib.nix args;
          in
          {
            lib = pkgslib;

            # add the formatter if supported
            packages = pkgslib.genPkgs {
              # TODO : add args support
            };

      };
    };
};
};
}
