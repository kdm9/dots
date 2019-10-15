function git-recover() {
    file="$1"
    if [ -z "$file" ]; then echo "USAGE: git-recover <filename>"; exit; fi
    git checkout "$(git rev-list -n 1 HEAD -- \"$file\")^" -- "$file"
}

function mkcd {
	mkdir -p "$1" && cd "$1"
}

function mkdatedir {
    d="$(date +%Y-%m-%d_${1})"
    mkdir -p "$d" && cd "$d"
}

function taskstatus() {
    if [ ! -e $HOME/.task ] || [ -z "$(which task 2>/dev/null)" ]
    then
        return
    fi
    dfile="$HOME/.zgen/lastzsh"
    now="$(date +%s)"
    lasttime="$(cat "$dfile" 2>/dev/null )"
    if [ -z "$lasttime" ] || [ $(($now - $lasttime)) -gt 300 ]
    then
        task next
        echo $now > "$dfile"
    fi
}
