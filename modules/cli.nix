{
  pkgs,
  dotfiles,
  user,
  ...
}:
let
  readShells = (import ./functions.nix).readShells;
  windowDup = pkgs.writeShellScriptBin "windowdup" ''
    ${dotfiles}/bin/windowdup.sh
  ''; # TODO: auto script to add binaries from folder
in
{
  home.packages = with pkgs; [
    # Shell
    zsh # Shell
    zsh-autosuggestions # Shell Recommendations
    zsh-fzf-tab # Shell FZF Integration
    zsh-powerlevel10k # Shell theme
    zsh-syntax-highlighting # Shell highlights

    # CLI Tools
    aspell # Spell Correction
    bat # Cat Replacment
    btop # Resource Monitor
    cliphist # Clipboard History
    dust # Folder Storage
    efibootmgr # Boot Entry Manager
    eza # Ls Replacement
    fd # Find Replacement
    fzf # Fuzzy-Finder
    helix-gpt # AI LSP
    helix # Text Editor
    lazygit # Git GUI
    libqalculate # Calculator
    lsof # Process Finder
    neofetch # Fetch
    neovim # Text Editor
    nmap # Internet Scanner
    onefetch # Git Fetch
    playerctl # Control media players
    ripgrep # Recursive Grep
    tldr # Help Pages
    trash-cli # Trash
    unzip # Unzip Files
    wget # Internet Download
    wl-clipboard # Clipboard Manager
    yazi # File Explorer
    zip # Zip Files
    zoxide # CD Replacement

    # User Scripts
    windowDup # Window Duplication

    # Compilers
    gcc # C++ Compiler
    cmake # Build System
  ];

  # Symlinks
  home.file = {
    # ZSH config & plugins
    ".zshrc".source = "${dotfiles}/zshrc.sh";
    ".zshsrc".text =
      readShells "/shells"
      + ''
        source "${../shells/shellcommands.sh}"
        source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
        source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      '';

    # Misc configs
    ".gitconfig".source = "${dotfiles}/git/.gitconfig";
    ".p10k.zsh".source = "${dotfiles}/.p10k.zsh";
    ".ssh/config".source = "${dotfiles}/ssh/config";
    ".gdbinit".source = "${dotfiles}/gdbinit";
  };

  # Configs located in .config
  xdg.configFile = {
    bat.source = "${dotfiles}/bat";
    "direnv/direnv.toml".source = "${dotfiles}/direnv.toml";
    ".gitignore".source = "${dotfiles}/git/.gitignore";
    nvim = {
      source = "${dotfiles}/nvim";
      recursive = true;
    };
    yazi.source = "${dotfiles}/yazi";
  };
}
