{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
    less.enable = true;
    mosh.enable = true;
    tmux = {
      enable = true;
      baseIndex = 1;
    };
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
