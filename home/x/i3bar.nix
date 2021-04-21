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
            # TODO: update to new format when i3status-rust updates to v0.20:
            # https://github.com/greshake/i3status-rust/blob/4d55b1d94ee09cbdefd805841fb54a2a4a0663a4/doc/blocks.md#available-format-keys-11
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{Mug}/{MTg}GB";
              warning_mem = 70.0;
              critical_mem = 90.0;
              # don't show swap
              clickable = false;
            }
            {
              block = "cpu";
              interval = 1;
              format = "{barchart}";
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
              block = "bluetooth";
              mac = config.my.secrets.bluetooth-mouse-mac-address;
              hide_disconnected = true;
              # TODO: use format when i3status-rust updates to v0.20
              # format = "{percentage}";
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
