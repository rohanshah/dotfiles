" Neovim Configuration
" --------------------

call plug#begin(stdpath('data') . '/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'kien/ctrlp.vim'
Plug 'udalov/kotlin-vim'
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

                                                    " disable arrow keys in normal mode
nmap <up> <nop>
nmap <down> <nop>
nmap <left> <nop>
nmap <right> <nop>

                                                    " TAB SETTINGS
set autoindent                                      " uses indent from the current line as indent for new line
set tabstop=4                                       " how many columns a tab counts for
set shiftwidth=4                                    " how many columns text is indendented with the reindent operations
set smarttab                                        " uses the value of shiftwidth when inserting or deleting tabs
set expandtab                                       " tabs should be spaces by default
noremap \t :setlocal expandtab!<CR>                 " change spaced tabs to actual tabs for current file only

set rnu                                             " relative line numbers
noremap \n :setlocal invrelativenumber<CR>          " toggle relative line number bar on/off

                                                    " SEARCH SETTINGS
set incsearch                                       " incremental search (i.e. search while typing)
set hlsearch                                        " highlights searched text
set ignorecase                                      " ignore case on searches
set smartcase                                       " override ignore case when search has uppercase in it
nmap \q :nohlsearch<CR>                             " mapping to turn off highlighting

                                                    " STATUS LINE
set laststatus=2                                    " always show the status line
set statusline=%t\                                  " tail of the filename with space after
set statusline+=%m                                  " modified flag
set statusline+=%r                                  " read only flag
set statusline+=%h\                                 " help flag
set statusline+=%=                                  " left/right separator
set statusline+=[column:%c]                         " current column
set statusline+=[line:%l]                           " current line
set statusline+=[%p%%]                              " percentage through file

                                                    " CTRLP SETTINGS
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 30
let g:ctrlp_regexp = 1                              " default to regexp search
let g:ctrlp_custom_ignore = '\v[\/](target|build)$' " ignore custom directories

                                                    " COC SETTINGS
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)


                                                    " MISCELLANEOUS SETTINGS
syntax enable                                       " enable syntax highlighting
filetype on                                         " enable filetype detection
filetype plugin on                                  " enable filetype detection
filetype plugin indent on                           " enable filetype detection
map <F12> :syntax enable<CR>                        " hot key to enable syntax highlighting
set autoread                                        " Auto-reload files that change on disk
au CursorHold * checktime
highlight Pmenu ctermfg=blue ctermbg=white          " coloring for Pmenu (used in autocomplete)
set maxmempattern=2000000                           " increase max memory for patterns because svgs are huge and cause vim to break
set wrap!                                           " don't wrap lines because I hate that
set hidden                                          " only hide the file when switching buffers otherwise it will not retain its undo history
map <F3> :NERDTreeToggle<CR>                        " Toggle NERDTree on and off
set backspace=2                                     " this makes backspace actually work in insert mode for some reason
set colorcolumn=81                                  " show colorcolumn -- lines of code should not be more that 80 characters
highlight ColorColumn ctermbg=lightblue             " make the colorcolumn white
set re=0

if (has("clipboard"))                               " Use the system clipboard if possible (https://vim.fandom.com/wiki/Accessing_the_system_clipboard)
  set clipboard=unnamedplus
endif

                                                    " put last
set background=dark                                 " set solarized to use the dark background
colorscheme solarized                               " make the colorscheme use solarize

                                                    " toggle background between light and dark
let t:is_dark = 1
function! Toggle_background()
    if t:is_dark == 0
        set background=dark
        let t:is_dark = 1
    else
        set background=light
        let t:is_dark = 0
    endif
endfunction
noremap \b :call Toggle_background()<CR>
