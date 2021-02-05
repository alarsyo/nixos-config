let
  bitwarden_rs = import ./bitwarden_rs.nix;
  bitwarden_rs-vault = import ./bitwarden_rs-vault.nix;
in
[
  bitwarden_rs
  bitwarden_rs-vault
]
