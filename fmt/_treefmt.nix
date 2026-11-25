# treefmt.nix
# flake-part module to specify how to format the repository
{ inputs, ... }:
let
  # defaults for formatting nix files
  nixFormatConfig = {
    programs = {
      autocorrect.enable = true;
      # all the nix formatter
      nixfmt.enable = true;
      statix.enable = true;
      deadnix = {
        enable = false;
        no-lambda-arg = false;
        no-lambda-pattern-names = true;
        no-underscore = true;
      };
      alejandra.enable = true;
    };
  };
in
{
  root ? "flake.nix",
  extraFmtConfig ? { },
}:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    rec {
      # set the treefmt config
      # it will set the perSystem.formatter option correctly
      treefmt = {
        projectRootFile = root;
      }
      // nixFormatConfig
      // extraFmtConfig;

      # add the formatter as a package
      packages =
        let
          pkg = inputs.treefmt-nix.lib.mkWrapper pkgs treefmt;
        in
        lib.mkIf (lib.meta.availableOn pkgs.stdenvNoCC.hostPlatform.system pkg) {
          fmt = pkg;
        };
    };
}
