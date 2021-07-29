{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.git;
in
{
  options.my.home.git.enable = (lib.mkEnableOption "Git configuration") // { default = true; };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      lfs.enable = true;

      userEmail = "antoine@alarsyo.net";
      userName = "Antoine Martin";

      extraConfig = {
        commit = { verbose = true; };
        core = { editor = "vim"; };
        init = { defaultBranch = "main"; };
        pull = { rebase = true; };
        rerere = { enabled = true; };
      };

      aliases = {
        push-wip = "push -o ci.skip";
        push-merge = "push -o merge_request.create -o merge_request.merge_when_pipeline_succeeds -o merge_request.remove_source_branch";
        push-mr = "push -o merge_request.create -o merge_request.remove_source_branch";
      };

      includes = [
        {
          condition = "gitdir:~/work/lrde";
          contents = { user = { email = "amartin@lrde.epita.fr"; }; };
        }
        {
          condition = "gitdir:~/work/prologin";
          contents = { user = { email = "antoine.martin@prologin.org"; }; };
        }
        {
          condition = "gitdir:~/work/epita";
          contents = { user = { email = "antoine4.martin@epita.fr"; }; };
        }
      ];
    };
  };
}