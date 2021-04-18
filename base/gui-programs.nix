{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    emacsPgtkGcc
    feh
    firefox
    flameshot
    pavucontrol
    slack
    spotify
    sqlite # needed for org-roam
    zathura
  ];

  fonts.fonts = with pkgs; [
    input-fonts
    emacs-all-the-icons-fonts
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  nixpkgs.config.input-fonts.acceptLicense = true;
}
