# my global zshrc! this one is versioned and should be symlinked to ~/.zshrc.



export EDITOR="nvim"

alias cd..="cd .."
alias ll="ls -alFGh"



# load zsh competure feature
autoload -Uz compinit && compinit
# case insensitive completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


# suggest from history
source ~/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# starship is a powerline or such thing. replaces setting a PS1 etc
eval "$(starship init zsh)"



# load machine-specific overrides
# we should probably do this as a last step?
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

