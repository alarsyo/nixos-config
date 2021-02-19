{ config, lib, ... }:
let
  mediaServices = with config.my.services; [
    jellyfin
  ];
  needed = builtins.any (service: service.enable) mediaServices;
in
{
  config.users.groups.media = lib.mkIf needed { };
}
