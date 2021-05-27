{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    # https://nixpk.gs/pr-tracker.html?pr=124336
    unstable-small.discord
    feh
    firefox
    element-desktop
    gnome3.nautilus
    mpv
    pavucontrol
    slack
    spotify
    tdesktop
    teams
    thunderbird
    zathura
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  programs.steam.enable = true;

  # NOTE: needed for home emacs configuration
  nixpkgs.config.input-fonts.acceptLicense = true;
}
