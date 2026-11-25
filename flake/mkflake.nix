# helper library for flake part
# avoid writing endlessly the same glue code
inputs@{
  flake-parts,
  nixpkgs,
  ...
}:
let
  inherit (nixpkgs) lib;
in
# simple helper
args:
flake-parts.lib.mkFlake
  # pass inputs to flake-parts
  { inherit inputs; }
  # top function
  (
    top:
    # default to all supported systems
    {
      systems = lib.systems.flakeExposed;
    }
    // (if (builtins.isFunction args) then (args top) else args)
  )
