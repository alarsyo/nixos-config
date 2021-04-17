# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let
  secrets = config.my.secrets;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.btrfs = {
    autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
  };

  networking.hostName = "boreal"; # Define your hostname.
  networking.domain = "alarsyo.net";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # List services that you want to enable:
  my.services = {
    wireguard = {
      enable = true;
      iface = "wg";
      port = 51820;

      net = {
        v4 = {
          subnet = "10.0.0";
          mask = 24;
        };
        v6 = {
          subnet = "fd42:42:42";
          mask = 64;
        };
      };
    };
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      windowManager.i3.enable = true;
      layout = "fr";
      xkbVariant = "us";
    };
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
