""""""""" Plugins """""""""""""
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.cache/vim-plug')
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'jalvesaq/Nvim-R', { 'for' : 'r'}
Plug 'gaalcaras/ncm-R'
Plug 'chrisbra/csv.vim'
Plug 'rickhowe/diffchar.vim'
Plug 'wellle/tmux-complete.vim'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'overcache/NeoSolarized'
Plug 'ncm2/ncm2-syntax'
Plug 'Shougo/neco-syntax'
Plug 'junegunn/goyo.vim'
Plug 'sirtaj/vim-openscad'
" Vim 8 only
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-criticmarkup'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

set termguicolors
set background=light
"colorscheme NeoSolarized
"#
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" snippets
let g:deoplete#enable_at_startup = 1
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsListSnippets = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:ultisnips_python_style = "sphinx"

" Pandoc config
let g:pandoc#biblio#sources = 'bcg'
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#folding#level = 0
let g:pandoc#folding#fdc = 0
let g:pandoc#formatting#equalprg = ''
let g:pandoc#formatting#mode = 'h'
"let g:pandoc#formatting#textwidth = 79
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#syntax#conceal#use = 0

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect


""""""""""""""""""" Indentation functions """"""""""""""""""""""""""""""""
fu! Sp1x()
	setlocal tabstop=1
	setlocal shiftwidth=1
	setlocal expandtab
	setlocal softtabstop=1
endf

fu! Sp2x()
	setlocal tabstop=2
	setlocal shiftwidth=2
	setlocal expandtab
	setlocal softtabstop=2
endf

fu! Sp4x()
	setlocal tabstop=4
	setlocal shiftwidth=4
	setlocal expandtab
	setlocal softtabstop=4
endf

fu! Sp8x()
	setlocal tabstop=8
	setlocal shiftwidth=8
	setlocal expandtab
	setlocal softtabstop=8
endf

fu! Tab4nx()
	setlocal tabstop=4
	setlocal shiftwidth=4
	setlocal noexpandtab
endf

fu! Tab8nx()
	setlocal tabstop=8
	setlocal shiftwidth=8
	setlocal noexpandtab
endf

fu! WrapMode()
    setlocal textwidth=0
    setlocal wrap
    setlocal linebreak
    let &l:showbreak = '  '
    noremap j gj
    noremap k gk
endf

let mapleader = ","
let maplocalleader = ","

filetype plugin indent on
syntax on

" Encoding
set fileformat=unix
set encoding=utf-8

" Max number of tabs with vim -p <FILES>
set tabpagemax=50


"""""""" Global defaults """"""""""""""

" Default options
call Sp4x()
set nofoldenable
set nohlsearch
set nonumber

autocmd BufNewFile,BufRead *.mdpres,*.md,*.Rmd,*.rst call WrapMode()
autocmd BufNewFile,BufRead *.yml,*.yaml call Sp2x()

"""""""" Plugin options """""""""
" NvimR
let R_assign = 0
"let R_in_buffer = 1
let R_openhtml = 0
let R_pdfviewer = "okular"
let R_applescript = 0

if $DISPLAY != ""
   let R_openpdf = 1
endif

" Goyo
let g:goyo_height = '100%'

function! s:goyo_enter()
    "silent !tmux set status off
    "silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    set noshowcmd
    "set scrolloff=999
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

function! s:goyo_leave()
    "silent !tmux set status on
    "silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    "set scrolloff=5
    set showcmd
endfunction
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" Ctags
set tags=./tags;$HOME

""""""""""" Keyboard shortcuts """"""""""

" Goyo
inoremap <leader>g <C-o>:Goyo<CR>
nnoremap <leader>g :Goyo<CR>

" Tab mgmt
noremap <leader>q <Esc>:tabp<CR>
noremap <leader>e <Esc>:tabn<CR>
noremap <leader>n <Esc>:tabnew
noremap <leader>h <Esc>:tabmove -1<CR>
noremap <leader>l <Esc>:tabmove +1<CR>

command Wq wq
command WQ wq
command W w
command Q q
nnoremap Q <nop>
map <F1> <Esc>
imap <F1> <Esc>

noremap j gj
noremap k gk

inoremap <leader>p <Esc>:set paste<CR>"+p<CR>:set nopaste<CR>a
nnoremap <leader>p <Esc>:set paste<CR>"+p<CR>:set nopaste<CR>

" Write all
inoremap <leader>w <Esc>:wa<CR>a
nnoremap <leader>w <Esc>:wa<CR>

set guicursor=
