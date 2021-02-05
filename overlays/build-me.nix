# File used in GitHub workflow to build my overlays
let
  pkgs = import <nixpkgs> { overlays = import ./.; };
in
with pkgs; [
  bitwarden_rs-postgresql
  bitwarden_rs-vault
]
