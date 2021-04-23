{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    feh
    firefox
    pavucontrol
    slack
    spotify
    tdesktop
    teams
    zathura
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # NOTE: needed for home emacs configuration
  nixpkgs.config.input-fonts.acceptLicense = true;
}
