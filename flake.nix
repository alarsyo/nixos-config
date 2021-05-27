{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-20.09";
    };

    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nixpkgs-unstable-small = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable-small";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "master";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self,
              nixpkgs,
              nixpkgs-unstable,
              nixpkgs-unstable-small,
              emacs-overlay,
              home-manager }: {
    nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules =
        let
          pkgsUnstable = import nixpkgs-unstable { inherit system; };
        in
        [
          ./poseidon.nix

          # hack to use an unstable home manager within a stable NixOS install,
          # do not reproduce... at home :clown_face:
          ({ config, utils, ... }: home-manager.nixosModules.home-manager {
            pkgs = pkgsUnstable;
            lib = pkgsUnstable.lib;
            inherit config utils;
          })
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alarsyo = import ./home;
            home-manager.verbose = true;
          }

          {
            nixpkgs.overlays = [
              (final: prev: {
                # packages accessible through pkgs.unstable.package
                unstable = pkgsUnstable;

                bitwarden_rs = pkgsUnstable.bitwarden_rs;
                bitwarden_rs-vault = pkgsUnstable.bitwarden_rs-vault;
              })
            ];
          }
        ];
    };
    nixosConfigurations.boreal = nixpkgs-unstable.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules =
        [
          ./boreal.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alarsyo = import ./home;
            home-manager.verbose = true;
          }

          {
            nixpkgs.overlays = [
              emacs-overlay.overlay

              (self: super: {
                packages = import ./pkgs { pkgs = super; };

                unstable-small = import nixpkgs-unstable-small {
                  inherit system;
                  config.allowUnfree = true;
                };
              })

              # uncomment this to build everything from scratch, fun but takes a
              # while
              #
              # (self: super: {
              #   stdenv = super.impureUseNativeOptimizations super.stdenv;
              # })
            ];
          }
        ];
    };
  };
}
