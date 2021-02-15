{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules =
        [
          ./poseidon.nix

          {
            nixpkgs.overlays = [
              # packages accessible through pkgs.unstable.package
              (final: prev: {
                unstable = nixpkgs-unstable.legacyPackages.${system};
              })
            ] ++ (import ./overlays);
          }
        ];
    };
  };
}
