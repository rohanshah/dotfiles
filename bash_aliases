#!/bin/bash

alias l='ls -l'
alias la='ls -lah'

alias memory="free -h"
alias space="df"

alias bim="vim"
alias im="vim"

alias datetime='date +"%Y%m%d%H%M%S"'

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

function remove-core-local() {
  rm -rf  ~/.m2/repository/com/blackfynn/blackfynn-core_2.12
  rm -rf  ~/.ivy2/cache/com.blackfynn/blackfynn-core_2.12
  rm -rf  ~/.ivy2/local/com.blackfynn/blackfynn-core_2.12
  echo "Removed Local Core"
}

function deploy-core-local() {
  remove-core-local
  cd ~/blackfynn/code/blackfynn-api/
  sbt core/clean core/publishM2 core/publishLocal
  cd -
}

function fix-vpn() {
  cd ~/blackfynn/code/operations/vpn
  ./masq.sh
  cd -
}

function docker() {
  if [[ $1 == "compose" ]]; then
      command docker-compose "${@:2}"
  else
      command docker "$@"
  fi
}
