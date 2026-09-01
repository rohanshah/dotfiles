## Neovim Cheat Sheet

### My keymaps

Leader is `\` (the default).

#### LSP

| Key | Does |
|---|---|
| `gd` `gD` `gi` `gr` | definition, declaration, implementation, references |
| `K` | hover docs |
| `<C-k>` | signature help |
| `ff` | format the buffer |
| `\rn` | rename symbol |
| `\ca` | code action (works in visual too) |
| `[d` `]d` | previous / next diagnostic |
| `\e` | show diagnostic in a float |

Python extras, via ruff:

| Key | Does |
|---|---|
| `\rf` | `:RuffFixAll` |
| `\oi` | `:RuffOrganizeImports` |

#### Toggles

| Key | Does |
|---|---|
| `\t` | tabs vs spaces (this file only) |
| `\n` | relative line numbers |
| `\q` | clear search highlight |
| `\c` | the 81-column marker |
| `\b` | dark / light background |

#### Everything else

| Key | Does |
|---|---|
| `<C-p>` | CtrlP file finder |
| `<F3>` | NERDTree |
| `<F12>` | kick syntax highlighting when it gets confused |
| `\ce` | ask Claude about the visual selection |

Arrow keys are disabled in normal mode on purpose.

#### Completion popup

| Key | Does |
|---|---|
| `<C-Space>` | open it |
| `<Tab>` / `<S-Tab>` | next / previous |
| `<CR>` | accept |
| `<C-e>` | cancel |
| `<C-b>` / `<C-f>` | scroll the doc window |

#### Gotcha

`\q` is bound twice. It clears search highlight, and that wins. The LSP's
"diagnostics to loclist" is also on `\q` and is therefore unreachable. Load
order in `init.lua` is what decides this, so don't reshuffle it casually.

### Plugins

Managed by lazy.nvim, pinned in `nvim/lazy-lock.json`.

    :Lazy          status
    :Lazy sync     update everything, then commit the lockfile
    :Lazy restore  go back to the pinned versions



### Editing a visual selection
  Visual highlight the lines you want with shift+v
  then type : to get :'<,'>

  Examples:

    Delete Trailing Whitespace from Selection
      :'<,'>s/\s\+$

    Delete Leading Whitespace from Selection
      :'<,'>le
    
    Add Something to the End of a Selection:
      :'<,'>s/$/whateveryouwant/
