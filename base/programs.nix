{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
    less.enable = true;
    mosh.enable = true;
    ssh = {
      startAgent = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
    tmux = {
      enable = true;
      baseIndex = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    # shell usage
    bat
    fd
    ripgrep
    wget

    # development
    git
    git-crypt
    gnupg
    pinentry-curses
    vim

    # terminal utilities
    htop
    stow
  ];
}
