# Nathan Hay's Dot File Repository
This is my system's configuration files for [NixOS](https://nixos.org/) and some general applications. The file structure follows:
- `dotfiles/`, the dot configuration files for those on the system.
- `hosts/`, the config files for devices.
    - `desktop`, Linux desktop running an Intel CPU and AMD graphics card.
    - `laptop`, Linux laptop running an Intel CPU.
- `modules/`, various separate parts of my Nix config.
    - `function.nix`, different functions which are used through my Nix config.
    - `packages.nix`, a list of all the packages installed.
    - `symlinks.nix`, rather than use homemanager directly I prefer using it as a symlink manager. This links config locations with the `dotfiles/` folder.
    - `theme.nix`, theming of a variety of applications mostly through the [Catppuccin Nix](https://github.com/catppuccin/nix) flake.
- `shells/`, the location of the shell flakes which are exposed as shell variables (ie: `rust_shell`).

## Commands
There are various unique commands that have been added to the ZSH config. Some of these include:
- `nixup`, update nix flakes.
- `nixre`, rebuild nix with option argument for host.
- `md`, mount the most recent drive, or optionally mount a specific drive.
