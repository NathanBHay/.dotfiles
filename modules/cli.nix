{ pkgs, dotfiles, ... }:
let
  readShells = (import ./functions.nix).readShells;
in {
  home.packages = with pkgs; [
    # Shell
    zsh                      # Shell
    zsh-autosuggestions      # Shell Recommendations
    zsh-fzf-tab              # Shell FZF Integration
    zsh-powerlevel10k        # Shell theme
    zsh-syntax-highlighting  # Shell highlights

    # CLI Tools
    aspell        # Spell Correction
    bat           # Cat Replacment
    btop          # Resource Monitor
    cliphist      # Clipboard History
    dust          # Folder Storage
    efibootmgr    # Boot Entry Manager
    eza           # Ls Replacement
    fd            # Find Replacement
    fzf           # Fuzzy-Finder
    gzip          # Expanded Zip
    lazygit       # Git GUI
    lsof          # Process Finder
    neofetch      # Fetch
    nmap          # Internet Scanner
    pavucontrol   # Audio Control
    playerctl     # Control media players
    ripgrep       # Recursive Grep
    trash-cli     # Trash
    tldr          # Help Pages
    unzip         # Normal Zip
    wget          # Internet Download
    wl-clipboard  # Clipboard Manager
    yazi          # File Explorer
    zip           # Compression
    zoxide        # CD Replacement

    # Compilers
    gcc           # C++ Compiler

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })
  ];

  fonts.fontconfig.enable = true;

  # Symlinks
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
    nvim.source = "${dotfiles}/nvim";
    yazi.source = "${dotfiles}/yazi";
  };
}
