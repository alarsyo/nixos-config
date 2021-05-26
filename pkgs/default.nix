{ pkgs }:
{
  sddm-sugar-candy = pkgs.callPackage ./sddm-sugar-candy {};
  beancount = pkgs.python3Packages.callPackage ./beancount.nix {};
}
