{ config, lib, options, ... }:

{
  config.age = {
    secrets =
      let
        toSecret = name: { ... }@attrs: {
          file = ./../../modules/secrets + "/${name}.age";
        } // attrs;
      in
        lib.mapAttrs toSecret {
          "gandi/api-key" = {};

          "users/alarsyo-hashed-password" = {};
          "users/root-hashed-password" = {};
        };
  };
}
