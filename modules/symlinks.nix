{ dotfiles, ... }:
let
  readShells = (import ./functions.nix).readShells;
  hyprConf = x: "${dotfiles}/hypr/${x}.conf";
in
{
  home.file = {
    # ZSH config & plugins
    ".zshrc".source = "${dotfiles}/zshrc.sh";
    "Pictures/.avatar.jpg".source = "${dotfiles}/.avatar.jpg";
    ".zshsrc".text = readShells "/shells" + ''
      source "${../shells/shellcommands.sh}"
      [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
      [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      [[ -r /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]] && source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
      [[ -r /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]] && source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    '';

    # Misc configs
    ".gitconfig".source = "${dotfiles}/git/.gitconfig";
    ".p10k.zsh".source = "${dotfiles}/.p10k.zsh";
    ".ssh/config".source = "${dotfiles}/ssh/config";
    ".gdbinit".source = "${dotfiles}/gdbinit";
  };

  # Configs located in .config
  xdg.configFile = {
    "direnv/direnv.toml".source = "${dotfiles}/direnv.toml";
    ".gitignore".source = "${dotfiles}/git/.gitignore";
    nvim = {
      source = "${dotfiles}/nvim";
      recursive = true;
    };
    "hypr/hypridle.conf".source = hyprConf "hypridle";
    "hypr/hyprlock.conf".source = hyprConf "hyprlock";
    "hypr/hyprsunset.conf".source = hyprConf "hyprsunset";
    "rofi/rofi.rasi".source = "${dotfiles}/rofi.rasi";
    "hypr/visuals.lua".source = "${dotfiles}/hypr/hyprland.lua";
    "hypr/bindings.lua".source = "${dotfiles}/hypr/bindings.lua";
  };
}
