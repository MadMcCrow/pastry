# flake/default.nix
# expose our flake tooling
{ inputs, ... }: {
  # provide lib functions
  flake.lib = {
    compat = import ./compat.nix;
    mkFlake = import ./mkflake.nix inputs;
  };
}
