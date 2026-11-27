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
    {
      # default to most common systems. avoid having all
      # linux architectures and freebsd support by default
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      # we could replace by "lib.systems.flakeExposed"
      # if we wanted to support better cross-compilation;
    }
    // (if (builtins.isFunction args) then (args top) else args)
  )
