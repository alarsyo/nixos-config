{ ... }:

{
  imports = [
    ./borg-backup.nix
    ./matrix.nix
    ./miniflux.nix
    ./monitoring.nix
    ./postgresql-backup.nix
  ];
}
