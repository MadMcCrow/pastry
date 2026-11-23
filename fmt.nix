# treefmt.nix
# flake-part module to specify how to format the repository
{
  withSystem,
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    rec {
      # treefmt settings
      treefmt = {
        # Used to find the project root
        projectRootFile = "flake.nix";

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
      # add formatter package
      packages.formatter = inputs.treefmt-nix.lib.mkWrapper pkgs treefmt;
    };
}
