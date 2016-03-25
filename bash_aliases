alias l='ls -l'
alias la='ls -lah'
alias memory="free -h"
alias space="df"
alias rm-swaps='find . -name "*.swp" -o -name "*.swo" -type f -delete'

function g() {
  grep \
      -rnI \
      --color=always \
      # Add exclusions, examples below:
      # --exclude=*.lein-repl-history \
      # --exclude=*.lein-env \
      # --exclude=*\.min\.js \
      # --exclude-dir=node_modules \
      # --exclude-dir=bower_components \
      # --exclude-dir=maps \
      "$@" . | less -R -S -
}

function cp-in() {
  DIR="$(dirname $1)"
  NEW_FILE=$DIR'/'$2
  cp $1 $NEW_FILE
}
