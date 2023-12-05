{
  config,
  lib,
  options,
  ...
}: {
  config.age = {
    secrets = let
      toSecret = name: {...} @ attrs:
        {
          file = ./../../modules/secrets + "/${name}.age";
        }
        // attrs;
    in
      lib.mapAttrs toSecret {
        "gandi/api-key" = {};

        "lohr/shared-secret" = {};

        "matrix-synapse/secret-config" = {
          owner = "matrix-synapse";
        };

        "microbin/secret-config" = {};

        "miniflux/admin-credentials" = {};

        "nextcloud/admin-pass" = {
          owner = "nextcloud";
        };

        "paperless/admin-password" = {};
        "paperless/secret-key" = {};

        "pleroma/pleroma-config" = {
          owner = "pleroma";
        };

        "restic-backup/hades-credentials" = {};
        "restic-backup/hades-password" = {};

        "users/alarsyo-hashed-password" = {};
        "users/root-hashed-password" = {};
      };
  };
}
