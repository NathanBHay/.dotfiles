# Nathan Hay's Dotfile Repository

This branch is structured for CachyOS plus the Nix package manager.

Nix handles:

- Home Manager dotfile links and user configuration
- Stylix-generated user/application theme files
- Hyprland user config
- Reproducible development shells in `shells/`

CachyOS handles:

- Kernel, bootloader, drivers, firmware, graphics, audio, networking, Bluetooth
- Users, groups, login shell, systemd services, display manager, portals
- System applications and hardware tools installed with `pacman`/`paru`

## Layout

- `flake.nix`: standalone Home Manager entry point.
- `modules/home.nix`: top-level Home Manager module.
- `modules/cli.nix`: shell, Git, SSH, Neovim, and CLI dotfile links.
- `modules/applications.nix`: user application config files.
- `modules/theme.nix`: Hyprland, rofi, kitty, and Hyprpanel config wiring.
- `modules/stylix.nix`: user-level Stylix theme settings.
- `dotfiles/`: source files linked into `$HOME`.
- `shells/`: separate flake for development shells.
- `CACHYOS_MIGRATION.md`: install and parity runbook for CachyOS.

Legacy NixOS files may remain only as migration reference and are not used by
the root flake.

## Apply Home Manager

```sh
nix run github:nix-community/home-manager -- switch --flake ~/.nixos#nathan@NathanLaptop
```

The shorter alias also exists:

```sh
nix run github:nix-community/home-manager -- switch --flake ~/.nixos#nathan
```

## Development Shells

```sh
nix develop ~/.nixos/shells#rust
nix develop ~/.nixos/shells#python
nix develop ~/.nixos/shells#cpp
```

The generated `~/.zshsrc` exposes aliases like `nix-rust`, `nix-python`, and
`envrc-rust`.
