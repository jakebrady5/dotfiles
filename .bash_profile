# if you install git via homebrew, or install the bash autocompletion via homebrew, you get __git_ps1 which you can use in the PS1
# to display the git branch.  it's supposedly a bit faster and cleaner than manually parsing through sed. i dont' know if you care
# enough to change it

# This function is called in your prompt to output your active git branch.
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function count_git_stash {
  git stash list 2> /dev/null | wc -l | sed 's/^ *//g'
}

function render_git_stash {
	if [[ $(count_git_stash) && $(count_git_stash) > 0 ]]; then
		echo " Stash: $(count_git_stash)"
	fi
}

# This function builds your prompt. It is called below
function prompt {
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  # local        CHAR="♥"
  local   BLUE="\[\e[0;49;34m\]"

  # PS1='\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$RED\$(parse_git_branch)$(render_git_stash) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]$BLUE//$RED $CHAR \[\e[0m\]'
  PS1='\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]\[\033[0;31m\]$(parse_git_branch)\[\e[33m\]$(render_git_stash) \[\e[0;32m\]\W\[\e[0m\]\n\[\e[0;31m\]\[\e[0;49;34m\]//\[\033[0;31m\] \[\e[0m\]'
    PS2='> '
    PS4='+ '
}

prompt

# Change the window title of X terminals
PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~}:$(parse_git_branch)\007"'

# Environment Variables
# =====================
  # Library Paths
  # These variables tell your shell where they can find certain
  # required libraries so other programs can reliably call the variable name
  # instead of a hardcoded path.

    # NODE_PATH
    # Node Path from Homebrew I believe
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

    # Those NODE & Python Paths won't break anything even if you
    # don't have NODE or Python installed. Eventually you will and
    # then you don't have to update your bash_profile

  # Configurations

    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'

    # Editors
    # Tells your shell that when a program requires various editors, use sublime.
    # The -w flag tells your shell to wait until sublime exits
    export VISUAL="atom -w"
    export SVN_EDITOR="atom -w"
    export GIT_EDITOR="atom -w"
    export EDITOR="atom -w"

# Aliases
# =====================
  # LS
  # alias l='ls -lah'
  #
  # # Git
  # alias gcl="git clone"
  # alias gst="git status"
  # alias gl="git pull"
  # alias gp="git push"
  # alias gd="git diff | mate"
  # alias gc="git commit -v"
  # alias gca="git commit -v -a"
  # alias gb="git branch"
  # alias gba="git branch -a"
  # alias gcam="git commit -am"
  # alias gbb="git branch -b"


# Case-Insensitive Auto Completion
  bind "set completion-ignore-case on"

# Postgres
export PATH=/usr/local/opt/openssl/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH

# Final Configurations and Plugins
# =====================
  # Git Bash Completion
  # Will activate bash git completion if installed
  # via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  # RVM
  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always
  [[ -s "/Users/$USER/.rvm/scripts/rvm" ]] && source "/Users/$USER/.rvm/scripts/rvm"  # This loads RVM into a shell session.

export NVM_DIR="/Users/jake/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.cargo/bin:$PATH"


export BUNDLER_EDITOR='atom -w'

batdiff() {
  git diff --name-only --diff-filter=d | xargs bat --diff
}
