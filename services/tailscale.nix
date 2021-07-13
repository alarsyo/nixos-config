{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.services.tailscale;
in
{
  options.my.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
    };

    # FIXME: remove when upgrading to 21.11, added to module by default
    systemd.services.tailscaled = {
      path = [ pkgs.procps ];
    };

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    # enable IP forwarding to use as exit node
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = true;
      "net.ipv4.ip_forward" = true;
    };
  };
}
