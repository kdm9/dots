" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'kdmurray91/kdm801-vim'
Plugin 'lervag/vimtex'
Plugin 'JuliaLang/julia-vim'
Plugin 'Rykka/InstantRst'
Plugin 'klen/python-mode'
Plugin 'vim-pandoc/vim-pandoc-syntax'
if v:version >= 704
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
endif
Plugin 'jpalardy/vim-slime'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'godlygeek/tabular'
" All of your Plugins must be added before the following line
call vundle#end()

""  Old plugins:
" Plugin 'baruchel/vim-notebook'
" Plugin 'beloglazov/vim-online-thesaurus'



"""""""" Plugin options """""""""

" pymode config
let g:pymode_lint_ignore = 'E501,W0611'
if has("python3")
  let g:pymode_python = 'python3'
else
  let g:pymode_python = 'python2'
endif
let g:pymode_syntax_print_as_function = 1
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope = 0

" Pandoc config
let g:pandoc#biblio#sources = 'b'
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#command#autoexec_on_writes = 0
let g:pandoc#command#autoexec_command = 'Pandoc #cite'
let g:pandoc#command#templates_file = expand('~/.vim/bundle/kdm801-vim/vim-pandoc-templates')
let g:pandoc#folding#level = 0
let g:pandoc#folding#fdc = 0
let g:pandoc#formatting#equalprg = ''
let g:pandoc#formatting#mode = 'h'
let g:pandoc#formatting#textwidth = 79
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#syntax#conceal#use = 1


" vimtex
let g:vimtex_format_enabled = 1
let g:vimtex_imaps_leader = ',f'
let g:vimtex_quickfix_mode = 0
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_method = 'zathura'

" snippets
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets=",ls"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

if has("python3")
  let g:UltiSnipsUsePythonersion = 3
else
  let g:UltiSnipsUsePythonVersion = 2
endif


" Gist
let g:gist_detect_filetype = 1


" SLIME
if exists('$TMUX')
    let g:slime_target = "tmux"
    let g:slime_paste_file = "/dev/shm/" . getpid() . ".slime_paste"
    let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.1"}
endif


""""""""""""""""""" Indentation functions """"""""""""""""""""""""""""""""
fu Sp1x()
	set tabstop=1
	set shiftwidth=1
	set expandtab
	set softtabstop=1
endf

fu Sp2x()
	set tabstop=2
	set shiftwidth=2
	set expandtab
	set softtabstop=2
endf

fu Sp4x()
	set tabstop=4
	set shiftwidth=4
	set expandtab
	set softtabstop=4
endf

fu Sp8x()
	set tabstop=8
	set shiftwidth=8
	set expandtab
	set softtabstop=8
endf

fu Tab4nx()
	set tabstop=4
	set shiftwidth=4
	set noexpandtab
endf

fu Tab8nx()
	set tabstop=8
	set shiftwidth=8
	set noexpandtab
endf

"""""""""""""""""" Custom filetype functions """""""""""""""""""""""""""""""
fu Mail_mode()
    set columns=80
    autocmd VimResized * if (&columns > 80) | set columns=80 | endif
    set wrap
    set linebreak
    nmap j gj
    nmap k gk
	highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
	call Sp2x()
	set spell spelllang=en_au
    if v:version >= 703
        set nofoldenable
    endif
endf

" From vim-markdown, which conflicts w/ pandoc
function! TableFormat()
    let l:pos = getpos('.')
    normal! {
    " Search instead of `normal! j` because of the table at beginning of file edge case.
    call search('|')
    normal! j
    " Remove everything that is not a pipe, colon or hyphen next to a colon othewise
    " well formated tables would grow because of addition of 2 spaces on the separator
    " line by Tabularize /|.
    let l:flags = (&gdefault ? '' : 'g')
    execute 's/\(:\@<!-:\@!\|[^|:-]\)//e' . l:flags
    execute 's/--/-/e' . l:flags
    Tabularize /|
    " Move colons for alignment to left or right side of the cell.
    execute 's/:\( \+\)|/\1:|/e' . l:flags
    execute 's/|\( \+\):/|:\1/e' . l:flags
    execute 's/ /-/' . l:flags
    call setpos('.', l:pos)
endfunction


"""""""""""""""""""""""""""""""""""""
" The main logic starts here
"""""""""""""""""""""""""""""""""""""

""""" Vim features """""

filetype plugin indent on
syntax on
set nocompatible

" Encoding
set fileformat=unix
set encoding=utf-8

" Max number of tabs with vim -p <FILES>
set tabpagemax=50

" Open help in new tab
cabbrev help tab help

" Secure crypto
if v:version >= 703
    set cm=blowfish
endif

if v:version >= 740
    set clipboard=unnamedplus
endif


"""""""" Global defaults """"""""""""""

" Default options
call Sp4x()
set nofoldenable
set nonumber
set textwidth=80
" set ignorecase
" set smartcase
set wildmenu  "menu for tab completion

" Bad whitespace
highlight BadWhitespace ctermbg=red guibg=red
match BadWhitespace /\s\+$/

highlight clear SpellBad
highlight SpellBad term=standout term=underline cterm=underline

""""""" FT-specific features """"""""""""""""""""""""""

" Call my FT-specific mode functions
autocmd BufRead,BufNewFile /tmp/mutt-* call Mail_mode()

autocmd BufNewFile,BufRead Snakefile* set syntax=snakemake
autocmd BufNewFile,BufRead *.rules set syntax=snakemake
autocmd BufNewFile,BufRead *.snakefile set syntax=snakemake
autocmd BufNewFile,BufRead *.snake set syntax=snakemake

autocmd BufNewFile,BufRead *.mdpres set filetype=pandoc
autocmd BufNewFile,BufRead *.yml,*.yaml call Sp2x()

autocmd BufNewFile,BufRead *.jl set filetype=julia


"""""" Keyboad shortcuts """"""""""""""""""""""""""""""
let mapleader = ","
let maplocalleader = ","

" Make
inoremap <leader>m <Esc>:wa<CR>:make<CR>i
nnoremap <leader>m <Esc>:wa<CR>:make<CR>

" Tab mgmt
noremap <leader>q <Esc>:tabp<CR>
noremap <leader>e <Esc>:tabn<CR>
noremap <leader>n <Esc>:tabnew

inoremap <leader>p <Esc>:set paste<CR>"+p<CR>:set nopaste<CR>a
nnoremap <leader>p <Esc>:set paste<CR>"+p<CR>:set nopaste<CR>

" Write all
inoremap <leader>w <Esc>:wa<CR>a
nnoremap <leader>w <Esc>:wa<CR>

" Sort selection
vnoremap <leader>s :sort<CR>

inoremap <leader>t <C-o>:%s/\s\+$//gc<CR>
nnoremap <leader>t <ESC>:%s/\s\+$//gc<CR>

" Ctags
set tags=./tags;$HOME
