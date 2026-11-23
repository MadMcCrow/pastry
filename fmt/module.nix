# treefmt.nix
# flake-part module to specify how to format the repository
args@{ inputs, ... }:
let
  # import shared settings
  treefmtConfig = import ./_treefmt.nix args;
in
{
  # expose the formatter config
  flake = {
    flakeModules.fmt =
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
        config = lib.mkIf config.pastry.fmt.enable (treefmtConfig {
          extraFmtConfig = config.pastry.fmt.extraConfig;
        });
      };
  };
}
