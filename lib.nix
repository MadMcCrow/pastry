# lib.nix
# flake part module for exposing helper functions,
# often used patterns, and other shortcuts
{ inputs, lib, ... }:
let
  # same logic is used by import-tree
  isPrivate = name : match "^[. _].*" n != null;

  # list all non-private directories
  listDir = dir : builtins.attrNames (
    lib.filterAttrs (n: t: t == "directory" && !isPrivate n) (builtins.readDir dir)
  );
in
{
flake.lib = {
  # avoid recursivity, expose directly
  inherit isPrivate listDir;

  # expose the compat function
  compat = import ./compat.nix;

  # get the name of a nix module
  modName = modPath : lib.unsafeDiscardStringContext (lib.removeSuffix ".nix" (baseNameOf modPath));

  # get all nix packages/modules in a directory
  # import-tree needs real paths, so root should be a path
  listNixPkgs = root : lib.flatten (map (d: inputs.import-tree.leaves (root + "/${d}")) (listDir root));

  # make an attributeSet of packages by callPackage paths
  genPkgs = { pkgs, paths, args } :
    # turn into an attrset
    lib.genAttrs'
    # filter available (maybe remove the parameter)
    (builtins.filter (p: lib.meta.availableOn pkgs.stdenv.hostPlatform p)
    # import packages
    (map (x: pkgs.callPackage x args) paths)) (p: lib.nameValuePair (lib.getName p) p);
};
}
