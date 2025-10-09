# ~/.zshrc

export PATH="./.venv/bin:$PATH"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# History settings for proper appending and sharing
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE        # Ignore commands that start with a space
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands in a row
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries to history file
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries before unique ones
setopt HIST_FIND_NO_DUPS        # Ignore duplicates when searching with up-arrow
setopt HIST_REDUCE_BLANKS       # Remove extra spaces
setopt SHARE_HISTORY            # Share history across terminals *carefully*
setopt INC_APPEND_HISTORY       # Append (not overwrite) after each command
setopt APPEND_HISTORY           # Safer append mode (legacy, still useful)

# Zsh options
setopt autocd extendedglob
setopt correct
setopt interactivecomments

# Plugins (adjust paths if needed)
fpath+=("/usr/share/zsh-completions")
fpath+=("/usr/share/zsh/site-functions")
autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh

bindkey -v

fvim() {
  local files
  files=$(fd --hidden --type f . | sk -m) || return
  nvim $files
}

# Aliases
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias lg='lazygit'
alias shutdown='systemctl poweroff'
alias fpy='cd ~/Lit/freshpy && source .venv/bin/activate'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'                 # Create intermediate dirs
alias cx='chmod +x'
alias vm='sudo systemctl start libvirtd.service'
alias cpnames="/home/nick/Lit/scripts/cpfilenames/copyfilenames.sh"
