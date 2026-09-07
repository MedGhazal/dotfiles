export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

ZSH_THEME=""

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-completions
	brew
	web-search
	git
)

fpath=(
  /opt/homebrew/share/zsh/site-functions
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions/src
  $fpath
)

autoload -U promptinit; promptinit
prompt pure

source "$ZSH/oh-my-zsh.sh"

alias nv="nvim"
alias zconfig="nvim ~/.zshrc"
alias zsource="source ~/.zshrc"
alias l="ls -lah"

typeset -U path
path=(
  /opt/homebrew/opt/postgresql@18/bin
  /opt/homebrew/bin
  $HOME/.npm-global/bin
  $path
)
export PATH
