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

    # setcap wrapper for network permissions
    bandwhich.enable = true;
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # shell usage
    fd
    ripgrep
    sd
    tmux
    tokei
    tree
    wget

    # development
    git
    git-crypt
    git-lfs
    gnumake
    gnupg
    pinentry-curses
    python3
    vim
    clang_11
    llvmPackages_11.bintools

    # terminal utilities
    bottom
    dogdns
    du-dust
    htop
    tealdeer
    unzip
    zip

    # nix pkgs lookup
    nix-index
  ];
}
