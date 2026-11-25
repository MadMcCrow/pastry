# packages/lib.nix
# functions for packaging
{
  pkgs,
  lib,
  ...
}:
rec {
  # make an attributeSet of packages by callPackage paths
  genPkgs =
    {
      paths,
      args ? { },
    }:
    # turn into an attrset
    lib.genAttrs'
      # filter available (maybe remove the parameter)
      (builtins.filter (p: lib.meta.availableOn pkgs.stdenv.hostPlatform p)
        # import packages
        (map (x: pkgs.callPackage x args) paths)
      )
      (p: lib.nameValuePair (lib.getName p) p);

  # check if supported on platform
  isSupported = pkg: lib.meta.availableOn pkgs.stdenvNoCC.hostPlatform.system pkg;

  # filter, used in perSystem for packages
  filterPkgs = pkgsAttrs: lib.filterAttrs (_: isSupported) pkgsAttrs;
}
