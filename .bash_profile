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
    # if ! [ `type -p docker` ]; then DOCKER="D "; fi
    # Here is where we actually export the PS1 Variable which stores the text for your prompt
    export PS1="$LIGHT_RED\[\e[m\]\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$LIGHT_RED\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]>> \[\e[0m\]"
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
    # Tells your shell that when a program requires various editors, use VS Code.
    # The -w flag tells your shell to wait until VS Code exits
    export VISUAL="code -w"
    export SVN_EDITOR="code -w"
    export GIT_EDITOR="code --wait"
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
    export PATH="$USR_PATHS:$PATH"
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
  # kill all processes by "name"
  # pkill name

  # find all process IDs by "name"
  # pgrep name

# Easily grep for a matching process
# USE: pfind postgres
function pfind {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

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
  alias grc="git rebase --continue"

# git reset (delete) the last $1 commits
function grs {
  git reset --hard HEAD~$1
}

# git rebase the last $1 commits
function grb {
  git rebase -i HEAD~$1
}
function gcb { # create new branch
  git checkout -b $1
}
function gco { # checkout existing branch
  git checkout $1
}
function gcm { # commit with a message
  git commit -m "$1"
}

function grau { # update fork (part 1)
  git remote add upstream $1
}

function gupdate { # update fork (part 2)
  git fetch upstream
  git pull upstream master
  git push -f
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
alias e='cd ~/eloquent-js; ls -lah'

# Docker--------------------
# alias dcap='dc exec ap bash' # dc = docker compose
# alias dcu='dc up -d'
# alias dcd='dc down'
alias dl='docker login'

# deletes all: stopped containers, dangling images, unused vols,
# unused networks, and build cache
alias dprune='docker system prune --volumes'

alias dps='docker ps -a' # show Docker processes, included ones exited
alias dp='docker pull'

# Docker images
alias di='docker images' # show all
alias drmi='docker rmi $(docker images -q)' # remove all images
function db {
  docker build -t $1 .
} # build image
function dr {
  docker run -it -e NODE_ENV='development' $1 bash
} # run image name and SSH into it
function dssh {
  docker exec -it -e NODE_ENV='development' $1 bash
} # SSH into running container ID

# Docker containers
alias dcls='docker container ls' # show all
alias dckill='docker kill $(docker ps -q)' # kill all containers
alias dcstop='docker stop $(docker ps -a -q)' # stop all containers
alias dcrm='docker rm $(docker ps -a -q)' # remove all containers

function dcl { # show real-time logs by image name
  docker logs -f $(docker ps -a -q --filter ancestor=$1)
}

function dkill { # kill 1 container by image name
  docker kill $(docker ps -a -q --filter ancestor=$1)
}
function drm { # force removal of 1 container by image name
  docker rm -f $(docker ps -a -q --filter ancestor=$1)
}

function ds { # stop container by image name
  docker stop $(docker ps -a -q --filter ancestor=$1)
}
function dst { # start container by image name
  docker start $(docker ps -a -q --filter ancestor=$1)
}
function drs { # restart container by image name
  docker restart $(docker ps -a -q --filter ancestor=$1)
}

alias cbp="curl https://raw.githubusercontent.com/rayning0/bash_profile/master/.bash_profile > ~/.bash_profile; source ~/.bash_profile"
function cdl { cd $1; ls -l; }
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
eval "$(direnv hook bash)"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export NVM_DIR=~/.nvm
. $(brew --prefix nvm)/nvm.sh
# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Users/rgan/.nvm/versions/node/v8.11.1/bin:/Library/Frameworks/Python.framework/Versions/3.6/bin:$PATH"
export PATH
alias mongod="/usr/local/mongodb/bin/mongod --config=/usr/local/mongodb/mongod.conf"
alias mongo="/usr/local/mongodb/bin/mongo"

npm config delete prefix
npm config set prefix $NVM_DIR/versions/node/v8.11.1

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=~/golib
export PATH=$PATH:$GOPATH/bin
export GOPATH=~/code
