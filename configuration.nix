# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./services
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "poseidon"; # Define your hostname.
  networking.domain = "alarsyo.net";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = "163.172.11.110";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = {
    address = "163.172.11.1";
    interface = "eno1";
  };
  networking.nameservers = [
    "62.210.16.6"
    "62.210.16.7"
  ];

  # Define a user account.
  users.users.root = {
    hashedPassword = lib.fileContents ./secrets/shadow-hashed-password-root;
  };
  users.users.alarsyo = {
    hashedPassword = lib.fileContents ./secrets/shadow-hashed-password-alarsyo;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3rrF3VSWI4n4cpguvlmLAaU3uftuX4AVV/39S/8GO9 alarsyo@thinkpad"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    fish
    git
    htop
    ripgrep
    stow
    tmux
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.fish.enable = true;

  # List services that you want to enable:
  my.services = {
    bitwarden_rs = {
      enable = true;
      privatePort = 8081;
      websocketPort = 3012;
    };

    borg-backup = {
      enable = true;
      repo = lib.fileContents ./secrets/borg-backup-repo;
    };

    gitea = {
      enable = true;
      privatePort = 8082;
    };

    miniflux = {
      enable = true;
      adminCredentialsFile = "${./secrets/miniflux-admin-credentials}";
      privatePort = 8080;
    };

    matrix = {
      enable = true;
      registration_shared_secret = (
        lib.fileContents ./secrets/matrix-registration-shared-secret
      );
    };

    monitoring = {
      enable = true;
      useACME = true;
      domain = "monitoring.${config.networking.domain}";
    };

    postgresql-backup = {
      enable = true;
    };
  };

  security.acme.acceptTerms = true;
  security.acme.email = "antoine97.martin@gmail.com";

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  boot.supportedFilesystems = [ "btrfs" ];

  nixpkgs.overlays = import ./overlays;
}

