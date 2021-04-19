{ config, lib, pkgs, ... }:
{
  options.my.home.emacs = with lib; {
    enable = mkEnableOption "Emacs daemon configuration";
  };

  config = lib.mkIf config.my.home.emacs.enable {
    services.emacs = {
      enable = true;
      # generate emacsclient desktop file
      client.enable = true;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };
  };
}
