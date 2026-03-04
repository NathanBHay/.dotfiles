# Shells: dotfiles zip python rust cpp js cryptopt write neuralnet ags constraint game java sagemath webscrape
{
  # TODO: Automate above
  description = "Various Development Shells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pwndgb.url = "github:pwndbg/pwndbg";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        x86 = "x86_64-linux";
      in
      {
        devShells = rec {
          dotfiles = pkgs.mkShell {
            packages = with pkgs; [
              nixd # Nix LSP
              lua-language-server # LUA LSP
              nixfmt # Nix Formatter
              shfmt # Shell Formatter
              stylua # Lua Formatter
              bash-language-server # Bash LSP
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
              python313 # Language
              black # Linter
              isort # Linter
              pyright # LSP

              # Packages
              python313Packages.jupyterlab # Juptyer
              python313Packages.matplotlib # Graphing
              python313Packages.numpy # Math
              python313Packages.pandas # Data Analysis
              python313Packages.scipy # Math
              python313Packages.tqdm # Progress Bar
              python313Packages.snakeviz # Profiler
              python313Packages.tkinter # GUI
              python313Packages.tabulate # Table
              python313Packages.requests # HTTP Requests
              python313Packages.beautifulsoup4 # Web Scraping
              marp-cli
            ];
          };

          webscrape = pkgs.mkShell {
            inputsFrom = [ python ];
            nativeBuildInputs = with pkgs; [
              playwright-driver.browsers
            ];
            packages = with pkgs; [
              python313Packages.playwright # Web Testing
            ];
            shellHook = ''
              export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
              export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
              export PLAYWRIGHT_HOST_PLATFORM_OVERRIDE="ubuntu-24.04"
            '';

          };

          sagemath = pkgs.mkShell {
            inputsFrom = [ python ];
            packages = with pkgs; [
              sage
            ];
          };

          neuralnet = pkgs.mkShell {
            inputsFrom = [ python ];
            packages = with pkgs; [
              kaggle # Data
              python313Packages.torch # Neural Nets
              python313Packages.torchvision # Vision
              python313Packages.pydicom # Dicom Files
              python313Packages.nibabel # Medical Imaging
              python313Packages.opencv4
              python313Packages.scikit-learn # Machine Learning
            ];
          };

          rust = pkgs.mkShell {
            packages = with pkgs; [
              rustc # Language
              cargo # Package manager
              rust-analyzer # LSP
              rustfmt # Formatter
              clippy # Linter
              mdbook # Documentation
              cargo-expand # Macro Expander
            ];

            RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          };

          cpp = pkgs.mkShell {
            packages = with pkgs; [
              ccls # LSP
              gdb # Debugger
              valgrind # Memory Profiler
              inputs.pwndgb.packages.${x86}.default # Fancy GDB
              mpi # Process Parallelization
              bc
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
              dart-sass # SCSS
            ];
          };

          cryptopt = pkgs.mkShell {
            inputsFrom = [
              cpp
              python
              js
              rust
            ];
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

          java = pkgs.mkShell {
            packages = with pkgs; [
              jdk24 # Java Development Kit
              jdt-language-server
              jetbrains.idea-community
            ];
          };

          write = pkgs.mkShell {
            packages = with pkgs; [
              pandoc # Text Converter
              texliveSmall # Latex
              texlab

              # Mermaid charts with auto reload
              nodePackages.mermaid-cli # Graphing
              entr # File Watcher
              presenterm
            ];
          };
        };
      }
    );
}
