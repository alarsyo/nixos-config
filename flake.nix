{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-24.05";
    };

    nixpkgs-unstable-small = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable-small";
    };

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "main";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
    };

    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      ref = "master";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    disko,
    ...
  } @ inputs:
    {
      nixosModules = {
        home = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alarsyo = import ./home;
          home-manager.verbose = true;
        };
      };

      overlays = import ./overlays;

      nixosConfigurations = let
        system = "x86_64-linux";
        shared_overlays =
          [
            (self: super: {
              packages = import ./pkgs {pkgs = super;};

              # packages accessible through pkgs.unstable.package
              unstable = import inputs.nixpkgs-unstable-small {
                inherit system;
                config.allowUnfree = true;
              };

              # power-profiles-daemon = self.unstable.power-profiles-daemon;
            })

            agenix.overlays.default
          ]
          ++ builtins.attrValues self.overlays;
        sharedModules =
          [
            agenix.nixosModules.default
            home-manager.nixosModules.default
            {
              nixpkgs = {
                overlays = shared_overlays;
                config.permittedInsecurePackages = [];
              };
              hardware.enableRedistributableFirmware = true;
            }
          ]
          ++ (nixpkgs.lib.attrValues self.nixosModules);
      in {
        hades = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules =
            [
              ./hades.nix
            ]
            ++ sharedModules;
        };

        boreal = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules =
            [
              ./boreal.nix

              {
                nixpkgs.overlays = [
                  # uncomment this to build everything from scratch, fun but takes a
                  # while
                  #
                  # (self: super: {
                  #   stdenv = super.impureUseNativeOptimizations super.stdenv;
                  # })
                ];
              }
            ]
            ++ sharedModules;
        };

        talos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            [
              inputs.nixos-hardware.nixosModules.framework-13-7040-amd
              disko.nixosModules.default
              ./talos.nix
            ]
            ++ sharedModules;
        };

        thanatos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            [
              disko.nixosModules.default
              ./thanatos.nix
            ]
            ++ sharedModules;
        };
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages =
        inputs.flake-utils.lib.flattenTree
        (import ./pkgs {inherit pkgs;});
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = [
          pkgs.alejandra
        ];
      };
    });
}
