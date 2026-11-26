# helper library for flake part
# avoid writing endlessly the same glue code
outer@{
  flake-parts,
  nixpkgs,
  ...
}:
let
  inherit (nixpkgs) lib;
in
# simple helper
inputs: args:
flake-parts.lib.mkFlake
  # pass all inputs to flake-parts
  { inputs = outer // inputs; }
  # top function
  (
    top:
    # default to all supported systems
    {
      systems = lib.systems.flakeExposed;
    }
    // (if (builtins.isFunction args) then (args top) else args)
  )
