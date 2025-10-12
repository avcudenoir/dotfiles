# ZSH Options

setopt auto_cd # cd by typing directory name if it's not a command
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_list # automatically list choices on ambiguous completion
setopt always_to_end # move cursor to end if word had one match

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=500000

HIST_STAMPS="yyyy-mm-dd"

COMPLETION_WAITING_DOTS="true"

export DISABLE_AUTO_TITLE="false"

bindkey -e
