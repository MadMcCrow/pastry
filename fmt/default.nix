args@{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    ./self.nix # format this project
    ./module.nix # format for other projects
  ];
}
