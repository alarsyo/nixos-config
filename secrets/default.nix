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
    paperless = import ./paperless { inherit lib; };
  };
}
