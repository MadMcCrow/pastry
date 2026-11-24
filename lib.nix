# lib.nix
# flake part module for exposing helper functions,
# often used patterns, and other shortcuts
{
  inputs,
  lib,
  ...
}:
let
  # shortcut
  itree = inputs.import-tree;

  # flake-parts helpers
  parts = import ./parts.nix inputs;

  # same logic is used by import-tree
  isPrivate = name: builtins.match "^[. _].*" name != null;

  # list all non-private directories
  listDir =
    dir:
    builtins.attrNames (
      lib.filterAttrs (n: t: t == "directory" && !isPrivate n) (builtins.readDir dir)
    );

  # get the name of a nix module
  modName = modPath: lib.unsafeDiscardStringContext (lib.removeSuffix ".nix" (baseNameOf modPath));

in
{
  flake.lib = {
    # avoid recursivity, expose directly
    inherit isPrivate listDir modName;

    # expose the compat function
    compat = import ./compat.nix;

    # expose the flake part helper
    inherit (parts) mkFlake;

    # get all nix packages/modules in a directory
    # import-tree needs real paths, so root should be a path
    listNixPkgs = root: lib.flatten (map (d: itree.leaves (root + "/${d}")) (listDir root));


    # list all child packages in a directory that are not the directory default
    listImportChildren = dir: itree (i: i.matchNot "^${dir}/default\\.nix$") (i: i.leaves dir);

    # generate an attributeSet of the form :
    # {
    #   xxxx = ./yyyyy/xxxx.nix;
    # }
    genModAttr =
      dir: builtins.listToAttrs (map (x: lib.nameValuePair (modName x) x) (itree.leaves dir));

    # importApply all leaves in a directory
    # with a function that takes a path.
    importApplyLeaves =
      {
        func,
        dir,
      }:
      map (x: lib.modules.importApply x (func x)) (itree.leaves dir);

  };
}
