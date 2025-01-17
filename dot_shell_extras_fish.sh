# Define aliases
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias suspend='systemctl suspend'
alias df='df -H'
alias du='du -H'
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias meminfo='free -m -l -t'
alias countFiles='find . -type f | wc -l'
alias removeOldContainers='docker rm (docker ps -q -f status=exited)'
alias removeOldImages='docker rmi (docker images --filter "dangling=true" -q --no-trunc)'
alias gbr="git branch | grep -v \"master\" | xargs git branch -D"
alias c_dryrun="chezmoi git pull -- --autostash --rebase && chezmoi diff"

alias assume="source $HOMEBREW_PREFIX/bin/assume.fish"
abbr --add mux zellij
abbr --add k kubectl

# Define functions
function up
    set DEEP $argv[1]
    if test -z "$DEEP"
        set DEEP 1
    end
    for i in (seq 1 $DEEP)
        cd ..
    end
end

function convertToUTF8
    # $argv[1] - input format; $argv[2] - input file; $argv[3] - output file
    iconv -f $argv[1] -t utf8 $argv[2] > $argv[3]
end

# Git related aliases
alias gits='git status'
alias gita='git add'
alias gitb='git branch'
alias gitc='git commit'
alias gitd='git diff'
alias gitgo='git checkout'

function fd
    cd (find $HOME -type d | fzf -i)
end

# cdf - cd into the directory of the selected file
function cdf
    set file (fzf +m -q $argv[1])
    set dir (dirname $file)
    cd $dir
end

function fe
    set files
    while read -l line
        set files $files $line
    end < (fzf-tmux --query=$argv[1] --multi --select-1 --exit-0)
    if test -n "$files"
        $EDITOR $files
    end
end

# fkill - kill process
function fkill
    set pid (ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if test -n "$pid"
        echo $pid | xargs kill -$argv[1]
    end
end

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
function fbr
    set branches branch
    git fetch
    set branches (git branch -a)
    set branch (echo $branches | fzf-tmux +m)
    git checkout (echo $branch | sed "s/.* //" | sed 's#remotes/[^/]*/##')
end



### Keybinds

# CTRL+E: fzf's fuzzy directory search
bind \ce fzf-cd-widget

function fish_greeting
cat $HOME/.config/fish/greeting.txt
end
