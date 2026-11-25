# default.nix
# give the flake outputs, without needing flakes enabled
_:
# TODO : replace flake compat with directly outputs
(import ./flake/compat.nix ./.).outputs
