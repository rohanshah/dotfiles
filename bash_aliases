#!/bin/bash

alias l='ls -l'
alias la='ls -lah'

alias memory="free -h"
alias space="df"

alias bim="vim"
alias im="vim"

alias ga="git add -p"
alias gb="git branch"
alias gc="git commit -m"
alias gd="git diff"
alias gs="git status"

alias push="git push -u origin HEAD"
alias pull="git pull"

alias datetime='date +"%Y%m%d%H%M%S"'

alias ctags="`brew --prefix`/bin/ctags"
alias ctags-compile="ctags -R -f .tags ."

function rm-ext() {
  find . -name "*.$1" -type f -delete
}

alias clean-branches="git branch | sed -E 's/master|\*|development|develop|dev//g' | tr '\n' ' ' | xargs git branch -D"

alias grep=ggrep
function g() {
  grep \
      -rnI \
      --color=always \
      --exclude=*\.min\.js \
      --exclude=.tags \
      --exclude-dir=.git \
      --exclude-dir=.idea \
      --exclude-dir=.terraform \
      --exclude-dir=target \
      --exclude-dir=build \
      --exclude-dir=macro \
      --exclude-dir=node_modules \
      --exclude-dir=bower_components \
      --exclude-dir=kubeconfigs \
      --exclude-dir=pyenv \
      --exclude-dir=pyenv2.7 \
      --exclude-dir=venv \
      --exclude-dir=.pytest_cache \
      --exclude-dir=.mypy_cache \
      --exclude-dir=.bloop \
      --exclude-dir=.metals \
      --exclude-dir=htmlreport \
      "$@" . | less -R -
}

function cmux() {
  if [ -d "$1" ]; then
    cd $1
  fi

  tmux -2 new -d -s $1 && tmux -2 attach -t $1
}

function amux() {
  tmux -2 attach -t $1
}

function docker() {
  if [[ $1 == "compose" ]]; then
      command docker-compose "${@:2}"
  else
      command docker "$@"
  fi
}
