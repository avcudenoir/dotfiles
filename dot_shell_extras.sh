alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias suspend='systemctl suspend'
alias df='df -H'
alias du='du -H'
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias meminfo='free -m -l -t'
alias countFiles='find . -type f | wc -l'
alias removeOldContainers='docker rm $(docker ps -q -f status=exited)'
alias removeOldImages='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias gbr="git branch | grep -v \"master\" | xargs git branch -D"

up() {
	DEEP=$1
	[ -z "${DEEP}" ] && { DEEP=1; }
	for i in $(seq 1 ${DEEP}); do cd ../; done
}

convertToUTF8() {
	# $1 - input format; $2 - input file; $3 - output file
	iconv -f "$1" -t utf8 "$2" >"$3"
}

# some commands are based on those included in gitconfig
alias gits='git status '
alias gita='git add '
alias gitb='git branch '
alias gitc='git commit'
alias gitd='git diff'
alias gitgo='git checkout '

fd() {
	cd "$(find "${HOME}" -type d | fzf -i)" || exit
}

# cdf - cd into the directory of the selected file
cdf() {
	local file
	local dir
	file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir" || exit
}

fe() {
	local files=()
	while IFS='' read -r line; do files+=("$line"); done < <(fzf-tmux --query="$1" --multi --select-1 --exit-0)
	[[ -n "${files[*]}" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fkill - kill process
fkill() {
	local pid
	pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

	if [ "x${pid}" != "x" ]; then
		echo "${pid}" | xargs kill -"${1:-9}"
	fi
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
	local branches branch

	git fetch
	branches=$(git branch -a) &&
		branch=$(echo "$branches" | fzf-tmux +m) && git checkout "$(echo "$branch" | sed "s/.* //" | sed 's#remotes/[^/]*/##')"
}
