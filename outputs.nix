# what to include for outputs
# TODO : move away from a flake-part module and instead
# write something that could be exposed as a non-flake output
{ inputs, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./flake
    ./fmt
    ./lib
    ./packages
  ];
}
