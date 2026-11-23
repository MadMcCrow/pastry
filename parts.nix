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
{
  # simple helper
  mkFlake =
    parts:
    flake-parts.lib.mkFlake { inherit inputs; } (
      _:
      (
        {
          # defaults to supporting every system
          systems = lib.systems.flakeExposed;
        }
        // parts
      )
    );
}
