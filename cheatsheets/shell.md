## Shell Cheat Sheet

zsh is the login shell. bash gets the same environment through
`shell/common.sh`, so both behave the same apart from zsh-only bits
(history options, completion, `shell/local.zsh`).

### Functions

| Command | Does |
|---|---|
| `g <pattern>` | recursive grep from here, perl regex, paged, skips junk dirs |
| `noascii` | find non-ASCII characters in the tree |
| `cheat [topic]` | open a cheatsheet; no argument lists them |
| `cmux [dir\|name]` | create or attach a tmux session, named after the directory |
| `amux <name>` | attach to an existing session by exact name |
| `wrapcat <file>...` | cat files inside code fences, for pasting into an LLM |
| `md <file.md>` | render markdown and open it in the browser |
| `pj <file.json>` | pretty-print JSON in place |
| `rm-ext <ext>` | delete every `*.<ext>` below here |

`g` and `noascii` skip `.git`, `node_modules`, `venv`, `target`, `build`,
`dist`, and friends. The list is `GREP_COMMON_EXCLUDES` in
`shell/functions.sh`.

### Aliases

| Alias | Runs |
|---|---|
| `l` / `la` | `ls -l` / `ls -lah` |
| `vim` `vi` `bim` `im` | all go to `nvim` |
| `ga` `gb` `gc` `gd` `gs` | `git add -p`, `branch`, `commit -m`, `diff`, `status` |
| `push` / `pull` | `git push -u origin HEAD` / `git pull` |
| `clean-branches` | delete every local branch except main/master/dev |
| `uuid` | a lowercase uuid, no newline |
| `datetime` | `YYYYMMDDHHMMSS`, handy for filenames |
| `password` | one strong password via `pwgen` |
| `caffeine` | keep the machine awake basically forever |
| `memory` / `space` | `vm_stat` / `df -h` |
| `grep` | GNU grep (`ggrep`), needed for `-P` |

### Where things live

    shell/common.sh      PATH and env, sourced by both shells
    shell/aliases.sh     the table above
    shell/functions.sh   the table above that
    shell/zshrc          zsh only: history, completion, prompt
    shell/bash_profile   bash equivalent
    shell/local.sh       secrets and work config, both shells, not in git
    shell/local.zsh      same but zsh only
    shell/sdkman.sh      sourced last, SDKMAN insists

Adding to PATH: use `path_prepend` / `path_append`. They skip directories
that don't exist and won't add the same one twice, so re-sourcing your
shell config doesn't grow PATH.

### tmux

| Key | Does |
|---|---|
| `<C-b> s` | session tree, sorted by name |

Mouse is on. Copy mode is vi keys.
