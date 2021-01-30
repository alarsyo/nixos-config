{ ... }:

{
  imports = [
    ./bitwarden_rs.nix
    ./borg-backup.nix
    ./matrix.nix
    ./miniflux.nix
    ./monitoring.nix
    ./postgresql-backup.nix
  ];
}
