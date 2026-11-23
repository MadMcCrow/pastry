# the bootstraping tool for simplifying other flakes
{
  description = "Pastry is a tool to simplify making flakes";
  inputs = {
    # nixpkgs
    # An indirection through the flake registry.
    # override when using this
    nixpkgs = {
      type = "indirect";
      id = "nixpkgs";
    };

    # flake support
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # allows working without flakes
    flake-compat = {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
      flake = false;
    };

    # import all implicitly
    import-tree.url = "github:denful/import-tree";

    # auto format
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # shim
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        systems = lib.systems.flakeExposed;
        imports = [
          ./lib.nix
          ./fmt.nix
        ];
      }
    );
}
