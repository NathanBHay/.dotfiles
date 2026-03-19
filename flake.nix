{
  description = "Nathan's Nixos Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      user = "nathan";
      dotfiles = ./dotfiles;
      coreModules =
        x:
        [ x ]
        ++ [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      desktopModules =
        x:
        (coreModules x)
        ++ [
          ./modules/display.nix
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
        ];
      specialArgs = { inherit inputs dotfiles user; };
    in
    {
      nixosConfigurations = {
        NathanDesktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs;
          modules = desktopModules ./hosts/desktop;
        };
        NathanLaptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs;
          modules = desktopModules ./hosts/laptop;
        };
        rpi0 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = specialArgs;
          modules = coreModules ./hosts/pi;
        };
        NathanInstall = nixpkgs.nixos {
          specialArgs = { inherit inputs user; };
          modules = [ ./hosts/installer ];
        };
      };
    };
}
