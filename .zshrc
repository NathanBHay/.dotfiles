# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Exports
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
alias ls=eza
alias la='ls -a'
alias ld='ls -D'
alias lf='ls -f'
alias cat=bat
alias xclip='xclip -se c'

# Ctrl-Binds
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Search History
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# History
HISTFILE=~/.zsh_history
HISTS=4096
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots

# Completions
eval "$(dircolors -b)"
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -T --color=always $realpath'
zstyle ':fzf-tab:complete:*' fzf-preview 'bat -p --color=always $realpath'

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/fzf-tab-source/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Commands
eval "$(zoxide init zsh --cmd cd)"
eval "$(fzf --zsh)"
