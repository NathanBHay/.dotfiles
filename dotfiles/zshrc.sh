# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Exports
export EDITOR=nvim
export VISUAL=nvim
export BROWSER='brave'
export WORDCHARS=${WORDCHARS/\/}
export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git"'
export FZF_DEFAULT_OPTS=" \
  --height=40% --layout=reverse --border --filepath-word --bind ctrl-z:ignore \
  --preview 'bat -p --color=always {}' --preview-window=right:40%:border-left \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8"

# Aliases
alias vim=nvim
alias lg=lazygit
alias ls='eza --icons'
alias la='ls -a'
alias lf='ls -f'
alias lt='ls -T'
alias mv='mv -v'
alias cp='cp -v'
alias rm='rm -v'
alias rt='trash-put -v'
alias find=fd
alias rcat="$(which cat)" # Just in case
alias cat='bat --theme="Catppuccin Mocha"'
alias grep='grep --color=auto'
alias pandoc='pandoc -V geometry:margin=3cm'
alias neofetch='neofetch --ascii_distro nixos_old'
alias ssh='kitty +kitten ssh'
alias du=dust
alias df='df -h'
alias yy=yazi

# Drive Mount
function md() {
  if [[ -z "$1" ]]; then
    device=$(dmesg | grep -i 'sd' | grep -o 'sd[b-z]' | tail -n 1)
    device="${device}1"
  else
    device="$1"
  fi
  udisksctl mount -b "/dev/$device"
}
# Nix Commands
NIX_LOC="$HOME/.nixos"
alias nixup="sudo nix flake update --flake '$NIX_LOC'"
alias nixup_shells="sudo nix flake update --flake $NIX_LOC/shells"
alias nixpack='nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix {}"'
alias nix-clean="sudo nix-collect-garbage -d && sudo nix-store --optimise"
nixre() {
  if [[ "$1" == "-b" || "$2" == "-b" ]]; then
    sudo nixos-rebuild boot --flake "$NIX_LOC"
  else
    sudo nixos-rebuild switch --flake "$NIX_LOC"
  fi

  # Rebuild GUI
  if [[ "$1" == "-g" || "$2" == "-g" ]]; then
    ags -q; nohup ags > /dev/null 2>&1 &
  fi
}
nixiso () {
  local f=${2:-iso}
  nix run nixpkgs#nixos-generators -- --format "$f" --flake "$NIX_LOC#$1" -o "$NIX_LOC/result"
}

# Keybindings
bindkey -e
typeset -A keybinds
keybinds=(
  khome   beginning-of-line
  kend    end-of-line
  kich1   overwrite-mode
  kdch1   delete-char
  kcuu1   history-beginning-search-backward
  kcud1   history-beginning-search-forward
  kcub1   backward-char
  kcuf1   forward-char
  kpp     beginning-of-buffer-or-history
  knp     end-of-buffer-or-history
)

for k in "${(@k)keybinds}"; do
  [[ -n "${terminfo[$k]}" ]] && bindkey "${terminfo[$k]}" "${keybinds[$k]}"
done

# Keys not included in terminfo
bindkey "^[[1;5D"   backward-word         # Ctrl+Left
bindkey "^[[1;5C"   forward-word          # Ctrl+Right
bindkey "^H"        backward-kill-word    # Ctrl+Backspace
bindkey "5~"        kill-word

# History
HISTFILE=~/.zsh_history
HISTSIZE=32000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots

# Allows # to be used in comments
setopt interactivecomments

# Completions
eval "$(dircolors -b)"
autoload -Uz compinit && compinit

# Cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -T --color=always $realpath'
zstyle ':fzf-tab:complete:*' fzf-preview 'bat -p --color=always $realpath'

# Plugins
source "${HOME}/.zshsrc"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Commands
eval "$(zoxide init zsh --cmd cd)"
eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"
