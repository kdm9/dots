function git-recover() {
    file="$1"
    if [ -z "$file" ]; then echo "USAGE: git-recover <filename>"; exit; fi
    git checkout "$(git rev-list -n 1 HEAD -- \"$file\")^" -- "$file"
}

function mkcd {
	mkdir -p "$1" && cd "$1"
}

