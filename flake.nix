{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09-small";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./poseidon.nix
          {
            nixpkgs.overlays = import ./overlays;
          }
        ];
    };
  };
}
