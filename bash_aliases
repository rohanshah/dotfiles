#!/bin/bash

alias l='ls -l'
alias la='ls -lah'

alias memory="free -h"
alias space="df"

alias bim="vim"
alias im="vim"

# alias docker-cleanup='docker rm -f $(docker ps -a -q) ;\
#                        docker rmi -f $(docker images -q) ;\
#                        docker rmi -f $(docker images -q -f dangling=true) ;\
#                        docker volume rm $(docker volume ls -qf dangling=true)'

function rm-ext() {
  find . -name "*.$1" -type f -delete
}

alias grep=ggrep
function g() {
  grep \
      -rnI \
      --color=always \
      --exclude=*\.min\.js \
      --exclude-dir=.git \
      --exclude-dir=target \
      --exclude-dir=node_modules \
      --exclude-dir=bower_components \
      --exclude-dir=components \
      --exclude-dir=kubeconfigs \
      --exclude-dir=pyenv \
      --exclude-dir=pyenv2.7 \
      "$@" . | less -R -
}

function cmux() {
  tmux -2 new -d -s $1 && tmux -2 attach -t $1
}

function amux() {
  tmux -2 attach -t $1
}

function pods() {
  kubectl get pods --namespace=$1
}

function connect-to-pod() {
  kubectl exec -it --namespace=$1 $2 bash
}
