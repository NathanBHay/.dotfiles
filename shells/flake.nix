# Shells: dotfiles zip python rust cpp js cryptopt write neuralnet
{
  # TODO: Automate above
  description = "Various Development Shells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells = rec {
          dotfiles = pkgs.mkShell {
            packages = with pkgs; [
              nixd # Nix LSP
              lua-language-server # LUA LSP
              nixfmt-classic # Nix Formatter
            ];
          };

          zip = pkgs.mkShell {
            packages = with pkgs; [
              unzip # Unzip
              zip # Zip
              unrar # Rar
              p7zip # 7zip
              tar # Tar
              gzip # Gzip
              bzip2 # Bzip
              xz # XZ
              lz4 # LZ4
              zstd # Zstd
            ];
          };

          python = pkgs.mkShell {
            packages = with pkgs; [
              python312 # Language
              black # Linter
              isort # Linter
              pyright # LSP

              # Packages
              python312Packages.jupyterlab # Juptyer
              python312Packages.matplotlib # Graphing
              python312Packages.numpy # Math
              python312Packages.pandas # Data Analysis
              python312Packages.scipy # Math
              python312Packages.tqdm # Progress Bar
              python312Packages.snakeviz # Profiler
              python312Packages.tkinter # GUI
              python312Packages.tabulate # Table
            ];
          };

          neuralnet = pkgs.mkShell {
            inputsFrom = [ python ];
            packages = with pkgs; [
              kaggle # Data
              python312Packages.torch # Neural Nets
              python312Packages.torchvision # Vision
              python312Packages.pydicom # Dicom Files
              python312Packages.nibabel # Medical Imaging
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

              mpi # Process Parallelization
            ];
            nativeBuildInputs = with pkgs; [
              autoconf
              automake
              libtool
              pkg-config
            ];
          };

          js = pkgs.mkShell {
            packages = with pkgs; [
              nodejs # Language
              typescript # Language
              prettierd # Formatter
              typescript-language-server # LSP
            ];
          };

          cryptopt = pkgs.mkShell {
            inputsFrom = [ cpp python js ];
            packages = with pkgs; [
              lcov # Code Coverage
              python312Packages.lcov-cobertura
              nasm # x86 Assembler
              gnuplot # Graphing
              calc # Calculator
              jq # JSON Processor
              (pkgs.callPackage ../packages/assemblyline { })
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
