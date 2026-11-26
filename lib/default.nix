# lib/default.nix
# entrypoint : do imports
_: {
  imports = [
    ./functions.nix
    ./options.nix
  ];
  # expose as a flake module for consumers
  flake.flakeModules.lib = ./options.nix;
}
