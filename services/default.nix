{ ... }:

{
  imports = [
    ./bitwarden_rs.nix
    ./borg-backup.nix
    ./gitea.nix
    ./matrix.nix
    ./miniflux.nix
    ./monitoring.nix
    ./nginx.nix
    ./postgresql-backup.nix
  ];
}
