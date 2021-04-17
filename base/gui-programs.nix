{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    feh
    firefox
    flameshot
    pavucontrol
    slack
    spotify
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
}
