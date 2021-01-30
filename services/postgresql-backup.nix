{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.postgresql-backup;
in {
  options.my.services.postgresql-backup = {
    enable = mkEnableOption "Backup SQL databases";
  };

  config = mkIf cfg.enable {
    services.postgresqlBackup = {
      enable = true;
      # Borg backup starts at midnight so create DB dump just before
      startAt = "*-*-* 23:30:00";
    };
  };
}
