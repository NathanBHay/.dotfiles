{
  description = "Nathan's Nixos Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:Aylur/ags";

    catppuccin.url = "github:catppuccin/nix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      dotfiles = ./dotfiles;
      coreModules = x: [ x ] ++ [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
      desktopModules = x: (coreModules x) ++ [
        ./modules/display.nix
        inputs.catppuccin.nixosModules.catppuccin
      ];
    in {
      nixosConfigurations = {
        NathanDesktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs dotfiles;};
          modules = desktopModules ./hosts/desktop;
        };
        NathanLaptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs dotfiles;};
          modules = desktopModules ./hosts/laptop;
        };
        NathanPi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {inherit inputs dotfiles;};
          modules = coreModules ./hosts/pi;
        };
        NathanInstall = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {inherit inputs;};
          modules = [ ./hosts/installer ];
        };
      };
    };
}
