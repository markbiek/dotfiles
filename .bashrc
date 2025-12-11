# If not running interactively, don't do anything:
[ -z "$PS1" ] && return
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ll='ls --format=vertical --color=auto -lah'
fi
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac
export PS1='\[\033[01;33m\]\u@\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/mysql/bin:~/public_html/bin
umask 022

export LS_OPTIONS='--color=auto'
eval "`dircolors`"

if [ -f "~/.git-completion.bash" ]; then
	source ~/.git-completion.bash
fi

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

export HISTSIZE=100000

# A8C sandbox-specific stuff
if [[ "$USER" == "wpdev" ]]; then
	source "~/.bash-includes/a8c/aliases"
	source "~/.bash-includes/a8c/paths"

	sudo xdebug check
	php -v | head -n 1 | awk '{print $1, $2}'
fi

# Load global aliases
source "~/.bash-includes/aliases"

if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]; then
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
fi
