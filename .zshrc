export ZSH="/Users/mohamedghazal/.oh-my-zsh"

ZSH_THEME="spaceship"
bindkey -v

plugins=(
	git
	vi-mode
	fzf
)

source $ZSH/oh-my-zsh.sh
SPACESHIP_GIT_BRANCH_COLOR=white
export PATH="/usr/local/opt/bison/bin:$PATH"
export FZF_BASE="/opt/homebrew/opt/fzf"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"

alias nv="nvim"
alias v="v"

alias vimdiff='nvim -d'
export EDITOR=nvim
export PATH="/opt/homebrew/sbin:$PATH"
alias python="/opt/homebrew/bin/python3.13"

export LD_LIBRARY_PATH=/usr/local/Cellar/instantclient-sqlplus/19.3.0.0.0dbru/lib:/usr/local/Cellar/instantclient-basic/19.3.0.0.0dbru/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/Cellar/instantclient-sqlplus/19.3.0.0.0dbru/bin:$PATH
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

source <(fzf --zsh)
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
