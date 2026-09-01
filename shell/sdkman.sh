# SDKMAN must be initialised LAST, after PATH is fully assembled, because its
# init script prepends its own shims and expects to win.
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh"
