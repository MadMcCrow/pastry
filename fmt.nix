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
    {
      root ? "flake.nix",
      extraFmtConfig ? { },
    }:
    {
      imports = [ inputs.treefmt-nix.flakeModule ];
      perSystem = { pkgs, ... }: rec {
        treefmt = {
          projectRootFile = root;
        }
        // nixFormatConfig
        // extraFmtConfig;
        packages.formatter = inputs.treefmt-nix.lib.mkWrapper pkgs treefmt;
      };
    };
  # dogfood our own function
in
(mkFormatterConfig { })
// {
  # expose the formatter config
  flake = {
    lib = { inherit mkFormatterConfig; };
    fmt = { inherit nixFormatConfig; };
    flakeModule.fmt =
      {
        config,
        lib,
        ...
      }:
      {
        options.pastry.fmt = {
          enable = lib.mkEnableOption "pastry auto format";
          extraConfig = lib.mkOption {
            description = "treefmt per system config";
            type = inputs.treefmt-nix.lib.submoduleWith lib { };
          };
        };
        imports = [ inputs.treefmt-nix.flakeModule ];
        config = lib.mkIf config.pastry.fmt.enable (mkFormatterConfig {
          extraFmtConfig = config.pastry.fmt.extraConfig;
        });
      };
  };
}
