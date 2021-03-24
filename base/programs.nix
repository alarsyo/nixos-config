{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
    mosh.enable = true;
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # shell usage
    bat
    ripgrep
    wget

    # development
    git
    gnupg
    pinentry-curses
    vim

    # terminal utilities
    htop
    stow
  ];
}
