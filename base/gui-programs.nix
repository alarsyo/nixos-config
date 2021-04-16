{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    flameshot
    alacritty
    slack
    discord
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
}
