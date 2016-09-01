alias l='ls -l'
alias la='ls -lah'

# vm aliases
alias gateway="ssh -A rshah@echo.rjmetrics.com"
alias ie="install_env.sh"
alias install-test="install_env.sh box-test rshah@rjmetrics.com \"Rohan Shah\""
alias bed="ed=vim blackbox_edit"
alias bcat="blackbox_cat"
alias memory="free -h"
alias space="df"
alias rm-swaps='find . -name "*.swp" -type f -delete'
alias stopped-services='service --status-all 2>&1 | grep "\[ - \]"'
alias cluster-metrics='cd ~; rm -r cluster-metrics; aws s3 sync s3://batcheetah-reports/cluster-metrics/ cluster-metrics/; cd cluster-metrics/'

function g() {
  grep \
      -rnI \
      --exclude=*.lein-repl-history \
      --exclude=*.lein-env \
      --color=always \
      --exclude=*\.min\.js \
      --exclude-dir=node_modules \
      --exclude-dir=bower_components \
      --exclude-dir=Framework \
      --exclude-dir=maps \
      "$@" . | less -R -
}
