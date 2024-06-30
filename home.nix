{ config, pkgs, dotfiles, ... }:
{
  home = {
    username = "nathan";
    homeDirectory = "/home/nathan";
    stateVersion = "24.05";
    file = {
      # ZSH config & plugins
      ".zshrc".source = "${dotfiles}/.zshrc";
      ".zshsrc".text = ''
        source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
        source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      '';

      # Misc configs
      ".p10k.zsh".source = "${dotfiles}/.p10k.zsh";
      ".gitconfig".source = "${dotfiles}/.gitconfig";
      ".ssh/config".source = "${dotfiles}/.ssh/config";
    };
  };

  # Configs located in .config 
  xdg.configFile = {
    nvim.source = "${dotfiles}/nvim";
    kitty.source = "${dotfiles}/kitty";
  };

  programs.home-manager.enable = true;
}
