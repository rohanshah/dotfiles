# Shell functions, shared by zsh and bash.

##### Searching #####

# Not readonly: this file must be safe to source more than once.
GREP_COMMON_EXCLUDES=(
  --exclude='*.min.js'
  --exclude='.tags'
  --exclude-dir={.git,.idea,.terraform,target,build,macro,node_modules,bower_components,kubeconfigs,pyenv,pyenv2.7,venv,.pytest_cache,.mypy_cache,.bloop,.metals,htmlreport,dist}
)

# g <pattern> — recursive perl-regexp grep through the tree, paged.
function g() {
  grep -rnIP --color=always "${GREP_COMMON_EXCLUDES[@]}" "$@" . | less -R -
}

# noascii — find non-ASCII characters anywhere in the tree.
function noascii() {
  grep -rnP --color=always "${GREP_COMMON_EXCLUDES[@]}" '[^[:ascii:]]' . | less -R -
}

##### Files #####

# rm-ext <extension> — delete every *.<extension> under the current directory.
function rm-ext() {
  find . -name "*.$1" -type f -delete
}

# pj <file.json> — pretty-print a JSON file in place.
function pj() {
  jq . "$1" > /tmp/pretty.json && mv /tmp/pretty.json "$1"
}

# wrapcat <file>... — cat files inside fenced code blocks, for pasting to an LLM.
function wrapcat() {
  if (( $# == 0 )); then
    printf 'usage: wrapcat file...\n' >&2
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

# md <file.md> — render markdown to HTML and open it.
function md() {
  local markdown_file="$1"
  local html_file="/tmp/$(basename "${markdown_file%.*}").html"
  pandoc "$markdown_file" -f gfm -s -o "$html_file" && open "$html_file"
}

##### Cheatsheets #####

# cheat [topic] — page a cheatsheet; with no argument, list what's available.
function cheat() {
  local cheatsheet_directory="$DOTFILES/cheatsheets"
  local topic="$1"

  if [[ -z "$topic" ]]; then
    printf 'usage: cheat <topic>\n\navailable topics:\n' >&2
    for cheatsheet in "$cheatsheet_directory"/*.md; do
      [[ -e "$cheatsheet" ]] || continue
      printf '  %s\n' "$(basename "${cheatsheet%.md}")" >&2
    done
    return 1
  fi

  if [[ ! -f "$cheatsheet_directory/$topic.md" ]]; then
    printf 'No cheatsheet for "%s". Run `cheat` to list topics.\n' "$topic" >&2
    return 1
  fi

  less "$cheatsheet_directory/$topic.md"
}

##### tmux #####

# cmux [directory|session-name] [session-name] — create or attach a session.
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

# amux <session-name> — attach to an existing session by exact name.
function amux() {
  local session_name="$1"

  if [[ -z "$session_name" ]]; then
    printf 'usage: amux <session-name>\n' >&2
    return 2
  fi

  tmux attach-session -t "=$session_name"
}
