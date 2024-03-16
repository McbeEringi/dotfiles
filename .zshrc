autoload -Uz compinit; compinit
# autoload -Uz predict-on; predict-on
setopt correct
setopt incappendhistory
setopt share_history
setopt hist_ignore_all_dups
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias hexedit='hexedit --color'

SAVEHIST=1000
HISTFILE=~/.zsh_history
PS1=" %F{#6ca}%.%f %# "
# PS1="[%n@%m %c]%# "