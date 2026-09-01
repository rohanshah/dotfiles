#!/bin/bash

alias l='ls -l'
alias la='ls -lah'

alias memory="free -h"
alias space="df"

alias uuid="uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | xargs echo"

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

alias cheat='less ~/dotfiles/cheatsheet.md'

alias caffeine='caffeinate -disu -t 1000000000'
alias password='pwgen --num-passwords=1 -snc'

function rm-ext() {
  find . -name "*.$1" -type f -delete
}

alias clean-branches="git branch | sed -E '/main|master|\*|development|develop|dev/d' | xargs git branch -D"

alias grep=ggrep

readonly GREP_COMMON_EXCLUDES=(
  --exclude='*.min.js'
  --exclude='.tags'
  --exclude-dir={.git,.idea,.terraform,target,build,macro,node_modules,bower_components,kubeconfigs,pyenv,pyenv2.7,venv,.pytest_cache,.mypy_cache,.bloop,.metals,htmlreport,dist}
)

function g() {
  grep -rnIP --color=always "${GREP_COMMON_EXCLUDES[@]}" "$@" . | less -R -
}

function noascii() {
    grep -rnP --color=always "${GREP_COMMON_EXCLUDES[@]}" '[^[:ascii:]]' . | less -R -
}

function pj() {
    jq . $1 > /tmp/pretty.json

    mv /tmp/pretty.json $1
}

# cmux [directory|session-name] [session-name]
function cmux() {
  local argument="${1:-$PWD}"
  local directory="$PWD"
  local session_name

  if [[ -d "$argument" ]]; then
    directory="$(cd "$argument" && pwd -P)" || return
    session_name="${2:-${directory##*/}}"
  else
    session_name="$argument"
  fi

  [[ -n "$session_name" ]] || session_name="root"

  tmux new-session -A -s "$session_name" -c "$directory"
}

# amux <session-name>
function amux() {
  local session_name="$1"

  if [[ -z "$session_name" ]]; then
    printf 'usage: amux <session-name>\n' >&2
    return 2
  fi

  tmux attach-session -t "=$session_name"
}

function wrapcat() {
  if (( $# == 0 )); then
    printf 'Usage: wrapcat file…\n' >&2
    return 1
  fi

  for file_path in "$@"; do
    if [[ ! -e $file_path ]]; then
      printf 'Warning: no such file: %s\n' "$file_path" >&2
      continue
    fi

    printf '```%s\n' "$file_path"
    cat -- "$file_path"
    printf '```\n'
  done
}

function md() {
    local markdown_file="$1"
    local html_file="/tmp/$(basename "${markdown_file%.*}").html"
    pandoc "$markdown_file" -f gfm -s -o "$html_file" && open "$html_file"
}
