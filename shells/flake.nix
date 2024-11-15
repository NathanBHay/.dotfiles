# Shells: dotfiles python rust cpp write
{
  description = "Various Development Shells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells = {
          dotfiles = pkgs.mkShell {
            packages = with pkgs; [
              nixd # Nix LSP
              lua-language-server # LUA LSP
              nixfmt-classic # Nix Formatter
            ];
          };

          python = pkgs.mkShell {
            packages = with pkgs; [
              python312 # Language
              black # Linter
              isort # Linter
              pyright # LSP
              kaggle # Data

              # Packages
              python312Packages.jupyterlab # Juptyer
              python312Packages.nibabel # Medical Imaging
              python312Packages.matplotlib # Graphing
              python312Packages.numpy # Math
              python312Packages.pandas # Data Analysis
              python312Packages.torch # Neural Nets
              python312Packages.torchvision # Vision
              python312Packages.pydicom # Dicom Files
              python312Packages.scipy # Math
              python312Packages.tqdm # Progress Bar
              python312Packages.snakeviz # Profiler
              python312Packages.tkinter # GUI
              python312Packages.tabulate # Table
            ];
          };

          rust = pkgs.mkShell {
            packages = with pkgs; [
              cargo # Package manager
              rust-analyzer # LSP
            ];
          };

          cpp = pkgs.mkShell {
            packages = with pkgs; [
              ccls # LSP
              gdb # Debugger
              valgrind # Memory Profiler

              python312
              lcov
              nasm
              jq
              calc
              mpi
              python312Packages.lcov-cobertura
              (pkgs.callPackage ../packages/assemblyline { })
            ];
            nativeBuildInputs = with pkgs; [
              autoconf
              automake
              libtool
              pkg-config
            ];
          };

          write = pkgs.mkShell {
            packages = with pkgs; [
              pandoc # Text Converter
              texliveSmall # Latex
            ];
          };
        };
      });
}
