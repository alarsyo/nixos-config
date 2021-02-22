{ ... }:

{
  imports = [
    ./bitwarden_rs.nix
    ./borg-backup.nix
    ./fail2ban.nix
    ./gitea.nix
    ./jellyfin.nix
    ./matrix.nix
    ./media.nix
    ./miniflux.nix
    ./monitoring.nix
    ./nginx.nix
    ./postgresql-backup.nix
    ./transmission.nix
  ];
}
