" https://github.com/vim-scripts/searchfold.vim

let mapleader = ','

set hlsearch
set incsearch
set cursorline
set smartindent

set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" The bundles you install will be listed here

filetype plugin indent on
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'tpope/vim-fugitive'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/supertab'
Bundle 'Raimondi/delimitMate'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'majutsushi/tagbar'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'vim-scripts/LaTeX-Suite-aka-Vim-LaTeX'
Bundle 'tpope/vim-surround'
Bundle 'mephux/bro.vim'
Bundle 'derekwyatt/vim-scala'

" Scala Bundles
" You need to check out appropriate ensime branch by hand by running ie.
" > git checkout scala-2.10
" in ensime plugin directory managed by vundle (probably ~/.vim/bundle/ensime). Also you'll need to run make in vimproc directory.
"Bundle "megaannum/self"
"Bundle "megaannum/forms"
"Bundle "Shougo/vimproc"
"Bundle "Shougo/vimshell"
"Bundle "aemoncannon/ensime"
"Bundle "megaannum/vimside"


" The rest of your config follows here

" Excess Line Length
augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

" Powerline setup
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

" Nerd Tree
map <F2> :NERDTreeToggle<CR>

" Python-mode Setup
" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 1

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8,pylint,mccabe"
" Auto check on save
let g:pymode_lint_write = 0

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

let g:pymode_utils_whitespaces = 0
let g:pymode_trim_whitespaces = 0

" Don't autofold code
let g:pymode_folding = 0

" Highlight trailing white space and delete on save
autocmd InsertLeave * match ErrorMsg '\s\+$'
autocmd InsertEnter * call clearmatches()
" autocmd BufWritePre * :%s/\s\+$//e

autocmd FileType tex set spell
autocmd FileType tex set tw=80
autocmd FileType tex set nowrap
autocmd InsertLeave *.tex highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
autocmd InsertLeave *.tex match OverLength /\%82v.*/

" automatically change window's cwd to file's dir
set autochdir

" I'm prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
endif

" solarized theme
syntax enable
set background=dark
colorscheme solarized

" Cursor Wrapping
set whichwrap+=<,>,h,l,[,]

" Ctags
let g:tagbar_ctags_bin="/opt/local/bin/ctags"

if has("autocmd")
  au  BufNewFile,BufRead *.bro set filetype=bro
  au BufRead,BufNewFile *.scala set filetype=scala
endif
