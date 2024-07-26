{ pkgs, dotfiles, ... }:
with (import ./functions.nix);
{
  home.file = {
    # ZSH config & plugins
    ".zshrc".source = "${dotfiles}/.zshrc";
    ".zshsrc".text = readShells "/shells" + ''
      source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
      source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
    '';

    # Misc configs
    ".gitconfig".source = "${dotfiles}/git/.gitconfig";
    ".p10k.zsh".source = "${dotfiles}/.p10k.zsh";
    ".ssh/config".source = "${dotfiles}/.ssh/config";
    "MEGA/Obsidian Vault/.obsidian" = {
      source = "${dotfiles}/.obsidian";
      recursive = true;
    };
  };

  # Configs located in .config 
  xdg.configFile = {
    bat.source = "${dotfiles}/bat";
    ".gitignore".source = "${dotfiles}/git/.gitignore";
    hypr.source = "${dotfiles}/hypr";
    kitty.source = "${dotfiles}/kitty";
    nvim.source = "${dotfiles}/nvim";
    swappy.source = "${dotfiles}/swappy";
    "vesktop/themes/custom.css".source = "${dotfiles}/vesktop/custom.css";
    yazi.source = "${dotfiles}/yazi";
  };
}
