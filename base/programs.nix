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
  };

  environment.systemPackages = with pkgs; [
    # shell usage
    bat
    fd
    ripgrep
    tmux
    tree
    wget

    # development
    git
    git-crypt
    gnupg
    pinentry-curses
    python3
    vim

    # terminal utilities
    htop
    stow
  ];
}
