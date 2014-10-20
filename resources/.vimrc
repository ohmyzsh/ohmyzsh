""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""
function! AutoSave()
    if filewritable(expand('%')) && &modified
        write
    endif
endfunction

function! ToggleIgnorecase()
    if g:ignorecase
        set noignorecase
        let g:ignorecase = 0
    else
        set ignorecase
        let g:ignorecase = 1
    endif
endfunction

function! TogglePaste()
    if g:paste
        set nopaste
        set number
        let g:paste = 0
    else
        set paste
        set nonumber
        let g:paste = 1
    endif
endfunction


""""""""""""""""""""""""""""""
" global setting
""""""""""""""""""""""""""""""
if exists(':DiffOrig')
    delcommand DiffOrig
endif
source $VIMRUNTIME/vimrc_example.vim
" Disable vim's mouse support
set mouse=""
" Don't break a longer line
setlocal textwidth=0

colorscheme desert
syntax enable

highlight ColorColumn ctermbg=Red
"highlight CursorLine ctermbg=Blue
highlight CursorColumn ctermbg=Blue

"set cursorline
set cursorcolumn
set colorcolumn=79
set nobackup
set number
set showmatch
set formatoptions+=mM
set ignorecase
set cindent
set autoindent
set shiftwidth=4
set tabstop=4
set expandtab
set list
set listchars=nbsp:-,tab:>-,trail:-
set encoding=utf-8 fileencodings=utf-8,euc-jp,GBK,cp936

" CursorHold : 100 millisecond
set updatetime=100

" statusline
set laststatus=2
set statusline=%<%f%m%r%h%y%{'['.(&fileencoding!=''?&fileencoding:&encoding).']['.&fileformat.']'.strftime('%a\ %b/%d\ %R')}%=%v[%b]\ %l/%L

" globle variables
let g:ignorecase = 0
let g:paste = 0

let mapleader = ","


""""""""""""""""""""""""""""""
" window setting
""""""""""""""""""""""""""""""
set splitright
set splitbelow
nnoremap w <c-w>
nnoremap <leader>j z.:split<cr>z.
nnoremap <leader>l z.:vsplit<cr>z.
nnoremap <leader>o <c-w>o
nnoremap = <c-w>=
nnoremap - <c-w>_


""""""""""""""""""""""""""""""
" Git setting
""""""""""""""""""""""""""""""
nnoremap <leader>gf :!git log --follow %<cr>


""""""""""""""""""""""""""""""
" other setting
""""""""""""""""""""""""""""""
nnoremap <space> i
nnoremap <tab> <esc>
vnoremap <tab> <esc>gV
onoremap <tab> <esc>
inoremap <tab> <esc>`^
inoremap <leader><tab> <tab>

nnoremap vv hebve
vnoremap <leader>s "ay/<c-r>a<cr>
nnoremap p "0p
noremap x "0x
nnoremap Q /~!@#$%^&*(<cr>
nmap gd vv,sN
vnoremap E $h
vnoremap B ^

nnoremap ma :mark A<cr>
nnoremap ga g'A
nnoremap mb :mark B<cr>
nnoremap gb g'B
nnoremap mc :mark C<cr>
nnoremap gc g'C

nnoremap gp g'P

nnoremap s :e#<cr>
nnoremap <leader>f :echo getcwd() . ' */* ' . expand('%')<cr>

" display motion
nnoremap <c-j> gj
nnoremap <c-k> gk
nnoremap <c-h> I<esc>
nnoremap <c-l> A<esc>

" write & quit
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>qq :q!<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>qa :qa<cr>
nnoremap <leader>qqa :qa!<cr>

nnoremap <leader>rr :edit %<cr>
nnoremap <leader>ee :edit ~/.vimrc<cr>
nnoremap <leader>ss :source ~/.vimrc<cr>:echo 'reload .vimrc!'<cr>

nnoremap <silent> <leader>ic :call ToggleIgnorecase()<cr>
nnoremap <silent> <leader>pp :call TogglePaste()<cr>

nnoremap <leader>fc :<c-x><c-f>
inoremap <c-]> <c-x><c-]>
inoremap <c-f> <c-x><c-f>
inoremap <c-d> <c-x><c-d>
inoremap <c-l> <c-x><c-l>


function! Dumper()
    let l:_filetype = expand('%:e')
    if l:_filetype == 'pl'
        owarn "\n---dump at here---\n";<cr>use Data::Dumper qw/Dumper/;<cr>warn Dumper $;<esc>i
    elseif l:_filetype == 'py'
        ofrom pprint import pprint<cr>pprint(locals())<esc>
    endif
endfunction
"nnoremap <leader>dd :call Dumper()<cr><cr>
nnoremap <leader>dd ofrom pprint import pprint<cr>pprint(locals())<esc>

""""""""""""""""""""""""""""""
" perl setting
""""""""""""""""""""""""""""""
nnoremap <leader>pl i#!/usr/bin/perl<cr><esc>xause strict;<cr><esc>xause warnings;<cr><cr>


""""""""""""""""""""""""""""""
" python setting
""""""""""""""""""""""""""""""
nnoremap <leader>py i#!/usr/bin/env python<cr># coding: utf8<cr><cr>#<<import>><cr>###standard###<cr>import sys<cr>###related###<cr>###local###<cr><cr>#<<global>><cr><cr>def main(args):<cr>pass<cr><cr>if __name__ == '__main__':<cr>main(sys.argv[1:])<cr><esc>


""""""""""""""""""""""""""""""
" netrw setting
""""""""""""""""""""""""""""""
let g:netrw_winsize = 30
nnoremap <leader>sp :Sexplore!<cr>:wincmd p<cr>:q<cr>:wincmd p<cr>


""""""""""""""""""""""""""""""
" Taglist setting
" http://www.vim.org/scripts/script.php?script_id=273
""""""""""""""""""""""""""""""
" ctags --list-kinds
highlight MyTagListTagName ctermfg=Green
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
" Improvement: in ~/.vim/plugin/taglist.vim
" 255         "autocmd BufEnter * call s:Tlist_Refresh()
" 256         autocmd CursorHold * call s:Tlist_Refresh()
let Tlist_Process_File_Always = 1
let Tlist_Ctags_Cmd = 'ctags'
    \.' --regex-python='
    \."'"
    \.'/if\s+__name__\s*==\s*(.+):/{\1}/f/'
    \."'"
    \.' --regex-perl='
    \."'"
    \.'/use (\w+(::\w+)*)/<<\1>>/p/'
    \."'"
    \.' --regex-perl='
    \."'"
    \.'/([_a-zA-Z]+)\s*=>\s*sub\s*\{/sub\{\1\}/l/'
    \."'"
    \.' --regex-perl='
    \."'"
    \.'/^(__\w+__)$/\1/l/'
    \."'"
    \.' --regex-perl='
    \."'"
    \.'/^subtest\s+(.*)\s*=>\s*sub\s*\{$/s:\1/s/'
    \."'"
" python language
let tlist_python_settings = 'python;i:import;c:class;m:member;f:function;v:variable'
" perl language
let tlist_perl_settings = 'perl;p:package;s:subroutine;c:constant;f:format;l:label;d:declaration'
" javascript language
let tlist_javascript_settings = 'javascript;f:function;c:class;m:method;p:property;v:variable'


""""""""""""""""""""""""""""""
" BufExplorer setting
" http://www.vim.org/scripts/script.php?script_id=42
" cd $HOME/.vim
" wget http://www.vim.org/scripts/download_script.php?src_id=14208 -O bufexplorer.zip
" unzip bufexplorer.zip
" :helptags ~/.vim/doc
"
" Bug: in ~/.vim/plugin/bufexplorer.vim
" 346         "call s:BEError("Escaped")
""""""""""""""""""""""""""""""
let g:bufExplorerShowRelativePath=1  " Show relative paths.


""""""""""""""""""""""""""""""
" winManager setting
" http://www.vim.org/scripts/script.php?script_id=95
" cd $HOME/.vim
" wget http://www.vim.org/scripts/download_script.php?src_id=754 -O winmanager.zip
" unzip winmanager.zip
" vim -c "helptags ~/.vim/doc" -c "q"
""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 1

" Improvement: in ~/.vim/plugin/winmanager.vim
" Append:
"if exists('g:AutoOpenWinManager') && g:AutoOpenWinManager
"    if filewritable(expand('%')) && exists('g:AutoOpenFiletype')
"        for _filetype in g:AutoOpenFiletype
"            if expand('%:e') == _filetype
"                autocmd VimEnter * nested call s:StartWindowsManager()
"                break
"            endif
"        endfor
"    endif
"endif
"let g:AutoOpenFiletype = ['pl', 'pm', 't', 'py', 'js']
let g:AutoOpenWinManager = 1

nnoremap <leader>wm :WMToggle<cr>
nnoremap <leader>wf ::FirstExplorerWindow<cr>


""""""""""""""""""""""""""""""
" autocmd setting
""""""""""""""""""""""""""""""
augroup GCursor
    autocmd!
    autocmd CursorHold * call AutoSave()

    autocmd CursorHold __Tag_List__ mark `
    autocmd CursorHold __Tag_List__ normal p``
augroup END

augroup GSwap
    autocmd!
    autocmd SwapExists * let v:swapchoice = 'e'
augroup END

augroup GBuf
    autocmd!
    autocmd BufEnter *.t setfiletype perl
    autocmd BufReadPost *.p[lm],*.t setlocal iskeyword+=:
    autocmd BufReadPost *.coffee setlocal shiftwidth=2

    autocmd BufReadPost * nnoremap <buffer> c ^i#<esc>j
    autocmd BufReadPost *.vim* nnoremap <buffer> c ^i"<esc>j
augroup END

augroup GWin
    autocmd!
    autocmd BufWinEnter \[Buf\ List\] setlocal nonumber
augroup END

augroup GVim
    autocmd!
    "autocmd VimEnter * if filereadable('.session.vim')
    "autocmd VimEnter * source .session.vim
    "autocmd VimEnter * endif
    "autocmd VimEnter * if filereadable('.viminfo')
    "autocmd VimEnter * rviminfo .viminfo
    "autocmd VimEnter * endif

    "autocmd VimLeave * if expand('%:t') !=# 'COMMIT_EDITMSG'
    "autocmd VimLeave * mksession .session.vim
    "autocmd VimLeave * wviminfo .viminfo
    "autocmd VimLeave * endif
augroup END
