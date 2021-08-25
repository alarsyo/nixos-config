{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs = {
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "master";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs: {
    nixosModules = {
      home = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.alarsyo = import ./home;
        home-manager.verbose = true;
      };
      nix-path = {
        nix.nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
        ];
      };
    };

    nixosConfigurations =
      let
        system = "x86_64-linux";
        shared_overlays = [
          (self: super: {
            packages = import ./pkgs { pkgs = super; };

            # packages accessible through pkgs.unstable.package
            unstable = import inputs.nixpkgs-unstable-small {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      in {

        poseidon = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./poseidon.nix

            self.nixosModules.nix-path

            home-manager.nixosModule
            self.nixosModules.home

            {
              nixpkgs.overlays = [
                (self: super: {
                  fastPython3 = self.python3.override {
                    enableOptimizations = true;
                    reproducibleBuild = false;
                    self = self.fastPython3;
                    pythonAttr = "fastPython3";
                  };

                  matrix-synapse = super.matrix-synapse.override {
                    python3 = self.fastPython3;
                  };
                })
              ] ++ shared_overlays;
            }
          ];
        };

        boreal = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./boreal.nix

            self.nixosModules.nix-path

            home-manager.nixosModule
            self.nixosModules.home

            {
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlay

                # uncomment this to build everything from scratch, fun but takes a
                # while
                #
                # (self: super: {
                #   stdenv = super.impureUseNativeOptimizations super.stdenv;
                # })
              ] ++ shared_overlays;
            }
          ];
        };

        zephyrus = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./zephyrus.nix

            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nixos-hardware.nixosModules.common-pc-laptop
            inputs.nixos-hardware.nixosModules.common-pc-ssd

            self.nixosModules.nix-path

            home-manager.nixosModule
            self.nixosModules.home

            {
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlay
              ] ++ shared_overlays;
            }
          ];
        };

      };
  } // inputs.flake-utils.lib.eachDefaultSystem (system: {
    packages =
      inputs.flake-utils.lib.flattenTree
        (import ./pkgs { pkgs = import nixpkgs { inherit system; }; });
  });
}
