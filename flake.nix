{
  description = "Nathan's Nixos Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    ags.url = "github:Aylur/ags";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      # Configuration Variables
      system = "x86_64-linux";
      dotfiles = ./dotfiles;
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs dotfiles;};
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };
    };
}
