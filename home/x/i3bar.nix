{ config, lib, pkgs, ... }:
let
  isEnabled = config.my.home.x.enable;
in
{

  config = lib.mkIf isEnabled {
    home.packages = with pkgs; [
      iw # Used by `net` block
      lm_sensors # Used by `temperature` block
      font-awesome
    ];

    programs.i3status-rust = {
      enable = true;

      bars = {
        top = {
          theme = "solarized-light";
          icons = "awesome5";

          blocks = [
            {
              block = "disk_space";
              path = "/";
              alias = "/";
              info_type = "available";
              unit = "GB";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "temperature";
              collapsed = false;
              interval = 10;
              format = "{max}°";
              # FIXME: specific to my AMD Ryzen CPU. Make this depend on
              # hostname or something else
              chip = "k10temp-pci-*";
              inputs = [ "Tccd1" ];
            }
            {
              block = "networkmanager";
              primary_only = true;
            }
            {
              block = "sound";
              driver = "pulseaudio";
            }
            # {
            #   block = "notify";
            # }
            {
              block = "time";
              interval = 5;
              format = "%a %d/%m %T";
              locale = "fr_FR";
              timezone = "Europe/Paris";
            }
          ];
        };
      };
    };
  };
}
