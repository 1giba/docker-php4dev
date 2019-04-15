# User specific aliases and functions
function parse_git_branch {
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

USER='\033[1;33m'
HOST='\033[1;34m'
DIRECTORY='\033[1;32m'
TIME='\033[1;35m'
BRANCH='\033[1;36m'
NOCOLOR='\033[0m'
export PS1="${USER}\u${NOCOLOR}@${HOST}\\h${NOCOLOR}:${DIRECTORY}\w${NOCOLOR} [${TIME}\A${NOCOLOR}] ${BRANCH}\$(parse_git_branch)${NOCOLOR}\n\\$ "