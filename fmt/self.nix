# treefmt.nix
# flake-part module to specify how to format the repository
args@{ inputs, ... }:
let
  # import shared settings
  treefmtConfig = import ./_treefmt.nix args;
  # dogfood our system
in
treefmtConfig { }
