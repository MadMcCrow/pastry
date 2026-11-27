# Pastry

> because the real flaky things are the croissant (qwaso) we met along the way. 

<rant> This repository is a bootstraping tool for when you use flakes but you wish you were'nt. You'll find the explaination [there](./FLAKE.md) </rant>.

Inspired by :
 - denful (import-tree);
 - flake-parts;
 - the understandable dislike flake and detsys receive.

 you can add it to your flake inputs like this :

```
inputs = {
pastry = {
  url = "github:MadMcCrow/pastry";
  inputs.nixpkgs.follows = "nixpkgs"; # always override my nixpkgs;
};
...
}
```

you can dedup your inputs further with these follows :
```
inputs.pastry = {
  url = "github:MadMcCrow/pastry";
  inputs = {
    nixpkgs.follows = "nixpkgs";
    import-tree.follows = "import-tree";
    flake-parts.follows = "flake-parts";
    treefmt-nix.follows = "treefmt-nix";
    # you can override flake-compat input, but I would advise against it.
    };
  };
```
note that if flakes were sensible, this deduplication could be automatic or handled by a map function.
