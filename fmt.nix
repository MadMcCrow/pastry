# treefmt.nix
# flake-part module to specify how to format the repository
{
  withSystem,
  inputs,
  ...
}:
let
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

  # helper to re-use formatter config in other flakes
  mkFormatterConfig =
    root:
    {
      # Used to find the project root
      projectRootFile = root;
    }
    // nixFormatConfig;
in
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  # expose the formatter config
  flake = {
    lib = { inherit mkFormatterConfig; };
    fmt = { inherit nixFormatConfig; };
  };

  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    {
      # treefmt settings
      treefmt = mkFormatterConfig "flake.nix";
      # add formatter package
      packages.formatter = inputs.treefmt-nix.lib.mkWrapper pkgs nixFormatConfig;
    };
}
