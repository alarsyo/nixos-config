{ config, lib, ... }:

with lib;

let
  cfg = config.my.services.lohr;
  my = config.my;
  domain = config.networking.domain;
in
{
  options.my.services.lohr = {
    enable = lib.mkEnableOption "Lohr Mirroring Daemon";

    home = mkOption {
      type = types.str;
      default = "/var/lib/lohr";
      example = "/var/lib/lohr";
      description = "Home for the lohr service, where data will be stored";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "lohr.${domain}" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = let
            laptopClientNum = my.secrets.wireguard.peers.laptop.clientNum;
          in
            "http://10.0.0.${toString laptopClientNum}:8000";
        };
      };
    };
  };
}
