# Find all files/directories from current directory recursively down into all folders
# USE: ff filename (ex: "ff '*spec.rb'" or "ff *spec.rb"). If can't find file,
# "cd .." into directory above current one, then try this again.
function ff {
  find . -name $1
}

# Like ff. Finds only files. Excludes directories.
# USE: f filename
function f {
  find . -type f -name $1
}

# Configuring Our Prompt
# ======================

  # This function is called in your prompt to output your active git branch.
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # This function builds your prompt. It is called below
  function prompt {
    # Define some local colors
    local         RED="\[\033[0;31m\]" # This syntax is some weird bash color thing I never
    local   LIGHT_RED="\[\033[1;31m\]" # really understood
    local   DOCKER=""
    # ♥ ☆ - Keeping some cool ASCII Characters for reference

    # Are we in Docker container?
    if ! [ `type -p docker` ]; then DOCKER="D "; fi

    # Here is where we actually export the PS1 Variable which stores the text for your prompt
    export PS1="$LIGHT_RED$DOCKER\[\e[m\]\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$LIGHT_RED\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]>> \[\e[0m\]"
      PS2='> '
      PS4='+ '
    }

  # Finally call the function and our prompt is all pretty
  prompt

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
    export VISUAL="code -w"
    export SVN_EDITOR="code -w"
    export GIT_EDITOR="code -w"
    export EDITOR="code -w"

  # Paths

    # The USR_PATHS variable will just store all relevant /usr paths for easier usage
    # Each path is seperate via a : and we always use absolute paths.

    # A bit about the /usr directory
    # The /usr directory is a convention from linux that creates a common place to put
    # files and executables that the entire system needs access too. It tries to be user
    # independent, so whichever user is logged in should have permissions to the /usr directory.
    # We call that /usr/local. Within /usr/local, there is a bin directory for actually
    # storing the binaries (programs) that our system would want.
    # Also, Homebrew adopts this convetion so things installed via Homebrew
    # get symlinked into /usr/local
    USR_PATHS="/usr/local"

    # Hint: You can interpolate a variable into a string by using the $VARIABLE notation as below.

    # We build our final PATH by combining the variables defined above
    # along with any previous values in the PATH variable.

    # Our PATH variable is special and very important. Whenever we type a command into our shell,
    # it will try to find that command within a directory that is defined in our PATH.
    # Read http://blog.seldomatt.com/blog/2012/10/08/bash-and-the-one-true-path/ for more on that.
    export PATH="${USR_PATHS}:${PATH}"

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# so you just type desk.
# HINT: It uses the built in USER variable to know your OS X username

# USE: desk
#      desk subfolder
function desk {
  cd /Users/$USER/Desktop/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Aliases
# =====================
  # kill processes
  alias kr="$(psg rack | awk '{print $2}')"
  alias kl="$(pgrep -n)"

  # LS
  alias l='ls -lah'

  # Git
  alias gl="git log"
  alias gr="git remote -v"
  alias gs="git status"
  alias gp="git pull"
  alias gd="git diff"
  alias gc="git commit -v"
  alias gca="git commit -v -a"
  alias ga="git add ."
  alias gb="git branch"
  alias gba="git branch -a"
  
function grb {
  git rebase -i HEAD\~$1
}

function gcb {
  git checkout -b $1
}

function gco {
  git checkout $1
}

function gcm {
  git commit -m "$1"
}

# Git Flow:

function gffs {
  git flow feature start $1
}

function gfff {
  git flow feature finish $1
}

  alias gpod="git push origin develop"
  alias gpdd="git push dev develop:master"

# Git Flow (from develop), to merge develop w/ master
function gfrs {
  git flow release start $1
}

function gfrf {
  git flow release finish $1
}

  alias gpom="git push origin master"
  alias grmd="git rebase master develop"
  alias gpsd="git push staging develop:master"

  alias rr="rake routes"

#################################################
alias be='bundle exec'
alias c='code .'
alias s='subl .'
alias r='rspec'
alias h='cd ~; ls -lah'
alias bp='source ~/.bash_profile'
alias b='code ~/.bash_profile'
alias t='dc exec ap tail -f log/development.log'

# Docker Compose
alias dcap='dc exec ap bash'
alias dcu='dc up -d'
alias dcd='dc down'
alias dcp='dc ps'
alias dcl='dc logs -f'

alias cbp="curl https://raw.githubusercontent.com/rayning0/bash_profile/master/.bash_profile > ~/.bash_profile; source ~/.bash_profile"

function dcr { dc restart $1; }
function dcb { dc exec $1 bash; }

function cdl { cd $1; ls -l;}
function be { bundle exec $1; }

# source ~/.git-prompt.sh
# export PS1="\w\$(__git_ps1) >"  # sets bash terminal prompt

function mkalias ()    # lets you make aliases from command line
{
    if [[ $1 && $2 ]]
    then
        echo "alias $1=\"$2\"" >> ~/.bashrc
        alias $1="$2"
    fi
}

export PATH=~/bin:$PATH

# To run from Docker container, do
# curl https://raw.githubusercontent.com/rayning0/bash_profile/master/.bash_profile > ~/.bash_profile; source ~/.bash_profile

eval "$(direnv hook bash)"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

alias mongod="/usr/local/mongodb/bin/mongod --config=/usr/local/mongodb/mongod.conf"
alias mongo="/usr/local/mongodb/bin/mongo"
