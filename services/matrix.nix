{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.matrix;

  federationPort = { public = 8448; private = 11338; };
  clientPort = { public = 443; private = 11339; };
  domain = config.networking.domain;
in {
  options.my.services.matrix = {
    enable = lib.mkEnableOption "Matrix Synapse";
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
    };

    services.matrix-synapse = {
      enable = true;
      server_name = domain;
      public_baseurl = "https://matrix.${domain}";

      listeners = [
        # Federation
        {
          bind_address = "127.0.0.1";
          port = federationPort.private;
          tls = false;  # Terminated by nginx.
          x_forwarded = true;
          resources = [ { names = [ "federation" ]; compress = false; } ];
        }

        # Client
        {
          bind_address = "127.0.0.1";
          port = clientPort.private;
          tls = false;  # Terminated by nginx.
          x_forwarded = true;
          resources = [ { names = [ "client" ]; compress = false; } ];
        }
      ];
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = let
        passToMatrix = port: {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      in {
        "matrix.${domain}" = {
          forceSSL = true;
          enableACME = true;

          locations."/" = passToMatrix clientPort.private;
        };

        "matrix.${domain}_federation" = rec {
          onlySSL = true;
          serverName = "matrix.${domain}";
          useACMEHost = serverName;

          listen = [
            { addr = "0.0.0.0"; port = federationPort.public; ssl = true; }
            { addr = "[::]"; port = federationPort.public; ssl = true; }
          ];

          locations."/" = passToMatrix federationPort.private;
        };

        "${domain}" = {
          onlySSL = true;
          enableACME = true;

          listen = [
            { addr = "0.0.0.0"; port = federationPort.public; ssl = true; }
            { addr = "[::]"; port = federationPort.public; ssl = true; }
          ];

          locations."/" = passToMatrix federationPort.private;
        };
      };
    };

    # For administration tools.
    environment.systemPackages = [ pkgs.matrix-synapse ];

    networking.firewall.allowedTCPPorts = [
      clientPort.public
      federationPort.public
    ];
  };
}
