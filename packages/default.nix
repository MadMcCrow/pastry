# packages/default.nix
# flake-parts imports
{ inputs, ... }: {
  # import our helper module
  imports = [ ./module.nix ];

  # add our lib under the system variant
  perSystem =
    args@{
      pkgs,
      lib,
      ...
    }:
    {
      # expose our lib
      lib = import ./_lib.nix args;
    };
}
