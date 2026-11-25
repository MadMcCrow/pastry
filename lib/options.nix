# lib/options.nix
# declare the option so we can merge flake.lib
{ inputs, ... }:
let
  # use the nixpkgs lib;
  inherit (inputs.nixpkgs) lib;

  # reuse option types for both root and perSystem
  libOption = lib.mkOption {
    type = with lib.types; lazyAttrsOf raw;
    default = { };
    description = "helper functions exposed by pastry";
  };
in
{
  options = {
    flake.lib = libOption;
    perSystem = inputs.flake-parts.lib.mkPerSystemOption { options.lib = libOption; };
  };
}
