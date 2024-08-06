# Shells: dotfiles python rust cpp write
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
              python312Packages.jupyterlab
              python312Packages.torch  # Neural Nets
          ];
        };

        rust = pkgs.mkShell {
          packages = with pkgs; [
            cargo          # Package manager
            rust-analyzer  # LSP
          ];
        };

        cpp = pkgs.mkShell {
          packages = with pkgs; [
            ccls
            gdb
            valgrind
            lcov
          ];
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
        };

        write = pkgs.mkShell {
          packages = with pkgs; [
            pandoc        # Text Converter
            texliveSmall  # Latex
          ];
        };
      };
    });
}
