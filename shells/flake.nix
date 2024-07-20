# Shells: dotfiles python rust
{
  description = "Various Development Shells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells = {
        dotfiles = pkgs.mkShell {
          packages = with pkgs; [
            nixd                 # Nix LSP
            lua-language-server  # LUA LSP
          ];
        };

        python = pkgs.mkShell {
          packages = with pkgs; [
              python312  # Language
              black      # Linter
              isort      # Linter
              pyright    # LSP

              # Packages
              python312Packages.torch  # Neural Nets
          ];
        };

        rust = pkgs.mkShell {
          packages = with pkgs; [
            cargo          # Package manager
            rust-analyzer  # LSP
          ];
        };
      };
    });
}
