""""""""" Plugins """""""""""""

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'freitass/todo.txt-vim'
"Plugin 'lervag/vimtex'
Plugin 'JuliaLang/julia-vim'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'fidian/hexmode'
"Plugin 'dhruvasagar/vim-table-mode'
if v:version >= 800
Plugin 'jalvesaq/Nvim-R'
endif
if v:version >= 704
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-rmarkdown'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
endif
if v:version >= 705
Plugin 'Valloric/YouCompleteMe'
endif
Plugin 'jpalardy/vim-slime'
Plugin 'godlygeek/tabular'
"Plugin 'octol/vim-cpp-enhanced-highlight'
if has("python") || has("python3")
Plugin 'klen/python-mode'
endif
Plugin 'junegunn/goyo.vim'
Plugin 'kdmurray91/kdm801-vim'

call vundle#end()



"""""""" Plugin options """""""""

" pymode config
let g:pymode_lint_ignore = 'E501,W0611'
if has("python3")
  let g:pymode_python = 'python3'
else
  let g:pymode_python = 'python'
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
let g:pandoc#syntax#conceal#use = 0

let g:table_mode_corner='|'

" vimtex
let g:vimtex_format_enabled = 1
let g:vimtex_imaps_leader = ',f'
let g:vimtex_quickfix_mode = 0
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_method = 'zathura'

" snippets
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips/"
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsListSnippets = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:ultisnips_python_style = "sphinx"

if has("python3")
  let g:UltiSnipsUsePythonersion = 3
else
  let g:UltiSnipsUsePythonVersion = 2
endif

" NvimR
let R_assign = 0
let R_in_buffer = 1
let R_applescript = 0
let R_tmux_split = 1
let R_notmuxconf = 1

" Goyo
let g:goyo_height = '100%'

function! s:goyo_enter()
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    set noshowcmd
    set scrolloff=999
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

function! s:goyo_leave()
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    set scrolloff=5
endfunction
autocmd! User GoyoLeave nested call <SID>goyo_leave()

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
	setlocal tabstop=1
	setlocal shiftwidth=1
	setlocal expandtab
	setlocal softtabstop=1
endf

fu Sp2x()
	setlocal tabstop=2
	setlocal shiftwidth=2
	setlocal expandtab
	setlocal softtabstop=2
endf

fu Sp4x()
	setlocal tabstop=4
	setlocal shiftwidth=4
	setlocal expandtab
	setlocal softtabstop=4
endf

fu Sp8x()
	setlocal tabstop=8
	setlocal shiftwidth=8
	setlocal expandtab
	setlocal softtabstop=8
endf

fu Tab4nx()
	setlocal tabstop=4
	setlocal shiftwidth=4
	setlocal noexpandtab
endf

fu Tab8nx()
	setlocal tabstop=8
	setlocal shiftwidth=8
	setlocal noexpandtab
endf

fu WrapMode()
    setlocal textwidth=0
    setlocal wrap
    setlocal linebreak
    let &l:showbreak = '  '
    noremap j gj
    noremap k gk
endf


"""""""""""""""""" Custom filetype functions """""""""""""""""""""""""""""""
fu Mail_mode()
    call WrapMode()
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
"cabbrev help tab help

" Secure crypto
if v:version >= 703
    set cm=blowfish
endif

if v:version >= 704
    set clipboard=unnamedplus
endif


"""""""" Global defaults """"""""""""""

" Default options
call Sp4x()
set nofoldenable
set nohlsearch
set nonumber
" set ignorecase
" set smartcase
set wildmenu  "menu for tab completion
set directory=~/.vim/tmp/


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

autocmd BufNewFile,BufRead *.mdpres,*.md set filetype=pandoc
autocmd BufNewFile,BufRead *.Rmd set filetype=rmarkdown
autocmd BufNewFile,BufRead *.mdpres,*.md,*.Rmd,*.rst call WrapMode()

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

" Ctags
set tags=./tags;$HOME
