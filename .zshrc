ZSH_DISABLE_COMPFIX=true
. ~/bin/z.sh

############################################################################
# Plugins
autoload -U zmv
autoload zcalc
############################################################################

############################################################################
# oh-my-zsh
if [[ $OSTYPE == darwin* ]]; then
	export ZSH_HOME=/Users/mark
	export DOTFILES_PRIVATE=/Users/mark/dev/dotfiles-private
	source ~/.zsh-includes/plugins/codetest/codetest.plugin.zsh
else
	export ZSH_HOME=/home/mark
	export DOTFILES_PRIVATE=/home/mark/dev/dotfiles-private
fi
export ZSH=$ZSH_HOME/.oh-my-zsh
export DISABLE_AUTO_UPDATE="true"

ZSH_THEME="ys"

plugins=(
  git
  aws
  brew
  composer
  jsontools
  laravel5
  npm
  rsync
  history
  history-substring-search
)

source $ZSH/oh-my-zsh.sh
############################################################################

############################################################################
# Command prompt
source ~/.zsh-includes/plugins/zsh-git-prompt/zshrc.sh
PROMPT='%~%b %# '
RPROMPT='$(git_super_status)' # git status goes on the right
############################################################################

############################################################################
# History

HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
############################################################################


################################################################################
# OS-specific Aliases
if [[ $OSTYPE == darwin* ]]; then
	source ~/.zsh-includes/os-specific/osx/aliases

	# A8C-specific aliases
	# These are only loaded on macOS.
	source ~/.zsh-includes/a8c/aliases
fi

# Global Aliases
source ~/.zsh-includes/aliases

############################################################################
# Settings
bindkey -v
setopt CORRECT

bindkey -v
bindkey '^R' history-incremental-pattern-search-backward

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

export LESS="-F -X $LESS"
############################################################################

if [[ $OSTYPE == darwin* ]]; then
	source ~/.zsh-includes/os-specific/osx/paths
	source ~/.zsh-includes/a8c/woa
fi
if [[ $OSTYPE == linux* ]]; then
	source ~/.zsh-includes/os-specific/linux/paths
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="~/.composer/vendor/bin/:~/.local/bin:$PATH"
eval "$(~/.local/bin/mise activate zsh)"
