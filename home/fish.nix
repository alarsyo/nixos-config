{ config, lib, ... }:
let
  cfg = config.my.home.fish;
in
{
  options.my.home.fish.enable = lib.mkEnableOption "Fish shell";

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      functions = {
        nfl = {
          body = ''
            set -l flags "--commit-lock-file"
            for flake in $argv
                set -a flags "--update-input" "$flake"
            end
            nix flake lock $flags
          '';
          description = "convenience wrapper around `nix flake lock` to only update certain flake inputs";
        };
      };
    };
  };
}
