export ZSH="/Users/mohamedghazal/.oh-my-zsh"

ZSH_THEME="spaceship"
bindkey -v

plugins=(
	git
	vi-mode
)

source $ZSH/oh-my-zsh.sh
SPACESHIP_GIT_BRANCH_COLOR=white
export PATH="/usr/local/opt/bison/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/sbin:$PATH"
