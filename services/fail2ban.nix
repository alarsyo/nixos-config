{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.services.fail2ban;
in {
  options.my.services.fail2ban = {
    enable = mkEnableOption "Enable fail2ban";
  };

  config = mkIf cfg.enable {
    services.fail2ban.enable = true;
  };
}
