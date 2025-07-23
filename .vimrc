" https://github.com/vim-scripts/searchfold.vim

let mapleader = ','

" let &colorcolumn=join(range(101,999),",")

set hlsearch
set incsearch
set cursorline
set smartindent

set nocompatible
set tw=100
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
set rtp+=~/.vim/bundle/vim-jsonnet/syntax/
set rtp+=~/.vim/bundle/vim-jsonnet/ftdetect/
set ignorecase
set smartcase

" Reduce update time so that Git Gutter updates more quickly
set updatetime=100
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" The bundles you install will be listed here

filetype plugin indent on
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'klen/python-mode'
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
Bundle 'wincent/Command-T'
" Bundle 'fholgado/minibufexpl.vim'
Bundle 'vim-scripts/EasyGrep'
" Bundle 'vim-scripts/LustyExplorer'
Bundle 'vim-scripts/yavdb'
Bundle 'junkblocker/patchreview-vim'
Bundle 'codegram/vim-codereview'
Bundle 'google/vim-jsonnet'
Bundle 'tpope/vim-sleuth'
Bundle 'scrooloose/syntastic'
Bundle 'Chiel92/vim-autoformat'
Bundle 'ashisha/image.vim'
Bundle 'google/vim-maktaba'
Bundle 'bazelbuild/vim-bazel'
Bundle 'chr4/nginx.vim'
Bundle 'spwhitt/vim-nix'
Bundle 'airblade/vim-gitgutter'
Bundle 'junegunn/fzf'
Bundle 'junegunn/fzf.vim'
Bundle 'github/copilot.vim'
Bundle 'jfo/hound.vim'
Bundle 'mattn/webapi-vim'
" Bundle 'ensime/ensime-vim'

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
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8,pylint,mccabe"
" Auto check on save
let g:pymode_lint_on_write = 0

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

" Syntastic python config
let g:syntastic_python_checkers = ['prospector']
let g:syntastic_python_prospector_args = "--profile python/prospector.yaml"

" Highlight trailing white space and delete on save
autocmd InsertLeave * match ErrorMsg '\s\+$'
autocmd InsertEnter * call clearmatches()
" autocmd BufWritePre * :%s/\s\+$//e

autocmd FileType tex set spell
autocmd FileType tex set tw=80
autocmd FileType tex set nowrap
autocmd InsertLeave *.tex highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
autocmd InsertLeave *.tex match OverLength /\%82v.*/

augroup jsonnet_template
  au!
  autocmd BufNewFile,BufRead *.jsonnet.template   set syntax=jsonnet
augroup END

" automatically change window's cwd to file's dir
set noautochdir

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

" Eclim Settings
" let g:EclimScalaSearchSingleResult = 'edit'
" let g:EclimCompletionMethod = 'omnifunc'
" let g:SuperTabDefaultCompletionType = 'context'
map <C-Space> :ScalaSearch<CR>

set wildignore=*.o,*.obj,*.bak,*.swp,*.class,*.pyc,*.md,*.min,*.txt,*.xml,*.jar,*.xml.gz,*.log,*resources/golden*,*.sql,*.q,*/node_modules/*,target/selenium/*,*/target/*,*/repo_universe/*,*/screenshots/*,*.json.gz,*.png,*.xml.gz,*/target/*
" au FileType java :so /Users/ahirreddy/.vim/bundle/JavaKit/vim/JavaKit.vim"

" CommandT Options
let g:CommandTMaxFiles=10000000
let g:CommandTFileScanner="git"

:set hidden

if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Inconsolata\ for\ Powerline:h15
   endif
endif

set noerrorbells
set novisualbell
set t_vb=
autocmd! GUIEnter * set vb t_vb=

autocmd QuickFixCmdPost *grep* cwindow

" Define a command to make it easier to use
command! -nargs=+ QFDo call QFDo(<q-args>)

" Function that does the work
function! QFDo(command)
    " Create a dictionary so that we can
    " get the list of buffers rather than the
    " list of lines in buffers (easy way
    " to get unique entries)
    let buffer_numbers = {}
    " For each entry, use the buffer number as 
    " a dictionary key (won't get repeats)
    for fixlist_entry in getqflist()
        let buffer_numbers[fixlist_entry['bufnr']] = 1
    endfor
    " Make it into a list as it seems cleaner
    let buffer_number_list = keys(buffer_numbers)

    " For each buffer
    for num in buffer_number_list
        " Select the buffer
        exe 'buffer' num
        " Run the command that's passed as an argument
        exe a:command
        " Save if necessary
        update
    endfor
endfunction

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

noremap <F5> :Autoformat<CR>
let g:formatdef_scalafmt = '"scalafmt --config .scalafmt.conf"'
let g:formatters_scala = ['scalafmt']

function! DiffBase(...)
    " Get the commit hash if it was specified
    let commit = a:0 == 0 ? 'databricks/master' : a:1

    " Get the result of git show in a list
    let flist = system('git diff --name-only ' . commit . '...HEAD | grep -v zzz')
    let flist = split(flist, '\n')

    " Create the dictionnaries used to populate the quickfix list
    let list = []
    for f in flist
        let dic = {'filename': f, "lnum": 1}
        call add(list, dic)
    endfor

    " Populate the qf list
    call setqflist(list)

    " Open the quickfix list
    vertical topleft cwindow
endfunction

map <F3> :GFiles<CR>
nnoremap ,t :GFiles<CR>

function! GgrepRegister()
    let l:register_content = getreg('a')
    execute "Ggrep " l:register_content
endfunction

nnoremap ,x :call GgrepRegister()<CR>

source ~/.vim/searchfold_0.9.vim

function! CopyRelativePathToGitRoot()
    " Find the git root directory
    let l:git_root = system('git rev-parse --show-toplevel')
    " Remove newline at the end
    let l:git_root = substitute(l:git_root, '\n\+$', '', '')

    " Get the full path of the current file
    let l:full_path = expand('%:p')

    " Calculate the relative path
    let l:relative_path = substitute(l:full_path, '^' . l:git_root . '/', '', '')

    " Copy the relative path to the + register (system clipboard)
    let @+ = l:relative_path
endfunction

function! DiffBaseDiff(...)
    " Get the commit hash if it was specified
    let commit = a:0 == 0 ? 'databricks/master' : a:1

    " Get the merge base
    let merge_base = system('git merge-base HEAD ' . commit)
    let merge_base = substitute(merge_base, '\n', '', 'g')

    " Get the list of changed files
    let flist = system('git diff --name-only ' . commit . '...HEAD | grep -v zzz')
    let flist = split(flist, '\n')

    " Open each file in a new tab with Gvdiff against merge base
    for f in flist
        " Skip empty filenames
        if empty(f)
            continue
        endif

        " Open file in new tab
        execute 'tabnew ' . f

        " Run Gvdiff against the merge base
        execute 'Gvdiff ' . merge_base
    endfor
endfunction

" Map the function to a command for easy execution
command! CopyGitRelativePath call CopyRelativePathToGitRoot()

" Map the command to ,c
nnoremap ,c :CopyGitRelativePath<CR>

set nobackup
set nowritebackup
set noswapfile
set backupdir=/dev/null
set directory=/dev/null
