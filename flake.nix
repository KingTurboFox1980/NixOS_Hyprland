{
  description = "NixOS flake for K10 (Hyprland, Impermanence)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, impermanence, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.K10 = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        # Enable impermanence module
        impermanence.nixosModules.impermanence

        # Main system config
        ./configuration.nix
      ];

      specialArgs = {
        inherit impermanence;
      };
    };
  };
}
