# my global zshrc! this one is versioned and should be symlinked to ~/.zshrc.



export EDITOR="nvim"

alias cd..="cd .."
alias ls="ls --color -F"
alias ll="ls -alh"
# -a:
# -l: "long format" more details columns
# -F: lägg / efter directory, etc
# -G: color _auto_ ... vi lägger istället --color alias som är: force
# -h: humanly readable filesiz ie kilo mega giga
# -t: sort by time midofied desc


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

