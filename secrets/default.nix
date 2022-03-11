{ pkgs, lib, config, ... }:
let
  inherit (lib)
    fileContents
    mkOption
  ;
in {
  options.my.secrets = let inherit (lib) types; in mkOption {
    type = types.attrs;
  };

  config.my.secrets = {
    miniflux-admin-credentials = fileContents ./miniflux-admin-credentials.secret;

    paperless = import ./paperless { inherit lib; };
  };
}
