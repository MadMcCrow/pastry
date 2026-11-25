# lib/default.nix
# entrypoint : do imports
_: {
  imports = [
    ./functions.nix
    ./options.nix
  ];
}
