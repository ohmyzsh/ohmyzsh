"==============================================================================
"    Copyright: Copyright (C) 2001-2010 Jeff Lanzarotta
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               bufexplorer.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
" Name Of File: bufexplorer.vim
"  Description: Buffer Explorer Vim Plugin
"   Maintainer: Jeff Lanzarotta (delux256-vim at yahoo dot com)
" Last Changed: Friday, 22 October 2010
"      Version: See g:bufexplorer_version for version number.
"        Usage: This file should reside in the plugin directory and be
"               automatically sourced.
"
"               You may use the default keymappings of
"
"                 <Leader>be  - Opens BE.
"                 <Leader>bs  - Opens horizontally window BE.
"                 <Leader>bv  - Opens vertically window BE.
"
"               Or you can use
"
"                 ":BufExplorer"                - Opens BE.
"                 ":BufExplorerHorizontalSplit" - Opens horizontally window BE.
"                 ":BufExplorerVerticalSplit"   - Opens vertically window BE.
"
"               For more help see supplied documentation.
"      History: See supplied documentation.
"==============================================================================

" Exit quickly if already running or when 'compatible' is set. {{{1
if exists("g:bufexplorer_version") || &cp
  finish
endif
"1}}}

" Version number
let g:bufexplorer_version = "7.2.8"

" Check for Vim version 700 or greater {{{1
if v:version < 700
  echo "Sorry, bufexplorer ".g:bufexplorer_version."\nONLY runs with Vim 7.0 and greater."
  finish
endif

" Public Interface {{{1
if maparg("<Leader>be") =~ 'BufExplorer'
  nunmap <Leader>be
endif

if maparg("<Leader>bs") =~ 'BufExplorerHorizontalSplit'
  nunmap <Leader>bs
endif

if maparg("<Leader>bv") =~ 'BufExplorerVerticalSplit'
  nunmap <Leader>bv
endif

nmap <script> <silent> <unique> <Leader>be :BufExplorer<CR>
nmap <script> <silent> <unique> <Leader>bs :BufExplorerHorizontalSplit<CR>
nmap <script> <silent> <unique> <Leader>bv :BufExplorerVerticalSplit<CR>

" Create commands {{{1
command! BufExplorer :call StartBufExplorer(has ("gui") ? "drop" : "hide edit")
command! BufExplorerHorizontalSplit :call BufExplorerHorizontalSplit()
command! BufExplorerVerticalSplit :call BufExplorerVerticalSplit()

" BESet {{{1
function! s:BESet(var, default)
  if !exists(a:var)
    if type(a:default)
      exec "let" a:var "=" string(a:default)
    else
      exec "let" a:var "=" a:default
    endif

    return 1
  endif

  return 0
endfunction

" BEReset {{{1
function! s:BEReset()
  " Build initial MRUList. This makes sure all the files specified on the
  " command line are picked up correctly.
  let s:MRUList = range(1, bufnr('$'))

  " Initialize one tab space array, ignore zero-based tabpagenr
  " since all tabpagenr's start at 1.
  " -1 signifies this is the first time we are referencing this
  " tabpagenr.
  let s:tabSpace = [ [-1], [-1] ]
endfunction

" Setup the autocommands that handle the MRUList and other stuff. {{{1
" This is only done once when Vim starts up.
augroup BufExplorerVimEnter
  autocmd!
  autocmd VimEnter * call s:BESetup()
augroup END

" BESetup {{{1
function! s:BESetup()
  call s:BEReset()

  " Now that the MRUList is created, add the other autocmds.
  augroup BufExplorer
    " Deleting autocommands in case the script is reloaded
    autocmd!
    autocmd TabEnter * call s:BETabEnter()
    autocmd BufNew * call s:BEAddBuffer()
    autocmd BufEnter * call s:BEActivateBuffer()

    autocmd BufWipeOut * call s:BEDeactivateBuffer(1)
    autocmd BufDelete * call s:BEDeactivateBuffer(0)

    autocmd BufWinEnter \[BufExplorer\] call s:BEInitialize()
    autocmd BufWinLeave \[BufExplorer\] call s:BECleanup()
    autocmd SessionLoadPost * call s:BEReset()
  augroup END

  " Remove the VimEnter event as it is no longer needed
  augroup SelectBufVimEnter
    autocmd!
  augroup END
endfunction

" BETabEnter {{{1
function! s:BETabEnter()
  " Make s:tabSpace 1-based
  if empty(s:tabSpace) || len(s:tabSpace) < (tabpagenr() + 1)
    call add(s:tabSpace, [-1])
  endif
endfunction

" BEAddBuffer {{{1
function! s:BEAddBuffer()
  if !exists('s:raw_buffer_listing') || empty(s:raw_buffer_listing)
    silent let s:raw_buffer_listing = s:BEGetBufferInfo(0)
  else
    " We cannot use :buffers! or :ls! to gather information 
    " about this buffer since it was only just added.
    " Any changes to the buffer (setlocal buftype, ...) 
    " happens after this event fires.
    "
    " So we will indicate the :buffers! command must be re-run.
    " This should help with the performance of the plugin.

    " There are some checks which can be performed 
    " before deciding to refresh the buffer list.
    let bufnr = expand('<abuf>') + 0

    if s:BEIgnoreBuffer(bufnr) == 1
      return 
    else
      let s:refreshBufferList = 1
    endif
  endif

  call s:BEActivateBuffer()
endfunction

" ActivateBuffer {{{1
function! s:BEActivateBuffer()
  let b = bufnr("%")
  let l = get(s:tabSpace, tabpagenr(), [])

  if s:BEIgnoreBuffer(b) == 1
    return
  endif

  if !empty(l) && l[0] == '-1'
    " The first time we add a tab Vim uses the current 
    " buffer as it's starting page, even though we are about
    " to edit a new page (BufEnter triggers after), so
    " remove the -1 entry indicating we have covered this case.
    let l = []
    let s:tabSpace[tabpagenr()] = l
  elseif empty(l) || index(l, b) == -1
    " Add new buffer to this tab buffer list
    let l = add(l, b)
    let s:tabSpace[tabpagenr()] = l

    if g:bufExplorerOnlyOneTab == 1
      " If a buffer can only be available in 1 tab page
      " ensure this buffer is not present in any other tabs
      let tabidx = 1
      while tabidx < len(s:tabSpace)
        if tabidx != tabpagenr()
          let bufidx = index(s:tabSpace[tabidx], b)
          if bufidx != -1
            call remove(s:tabSpace[tabidx], bufidx)
          endif
        endif
        let tabidx = tabidx + 1
      endwhile
    endif
  endif

  call s:BEMRUPush(b)

  if exists('s:raw_buffer_listing') && !empty(s:raw_buffer_listing)
    " Check if the buffer exists, but was deleted previously
    " Careful use of ' and " so we do not have to escape all the \'s
    " Regex: ^\s*bu\>
    "        ^ - Starting at the beginning of the string
    "        \s* - optional whitespace
    "        b - Vim's buffer number
    "        u\> - the buffer must be unlisted
    let shortlist = filter(copy(s:raw_buffer_listing), "v:val.attributes =~ '".'^\s*'.b.'u\>'."'")

    if !empty(shortlist)
      " If it is unlisted (ie deleted), but now we editing it again 
      " rebuild the buffer list.
      let s:refreshBufferList = 1
    endif
  endif
endfunction

" BEDeactivateBuffer {{{1
function! s:BEDeactivateBuffer(remove)
  let _bufnr = str2nr(expand("<abuf>"))

  call s:BEMRUPop(_bufnr)

  if a:remove
    call s:BEDeleteBufferListing(_bufnr)
  else
    let s:refreshBufferList = 1
  endif
endfunction

" BEMRUPop {{{1
function! s:BEMRUPop(buf)
  call filter(s:MRUList, 'v:val != '.a:buf)
endfunction

" BEMRUPush {{{1
function! s:BEMRUPush(buf)
  if s:BEIgnoreBuffer(a:buf) == 1
    return
  endif

  " Remove the buffer number from the list if it already exists.
  call s:BEMRUPop(a:buf)

  " Add the buffer number to the head of the list.
  call insert(s:MRUList,a:buf)
endfunction

" BEInitialize {{{1
function! s:BEInitialize()
  let s:_insertmode = &insertmode
  set noinsertmode

  let s:_showcmd = &showcmd
  set noshowcmd

  let s:_cpo = &cpo
  set cpo&vim

  let s:_report = &report
  let &report = 10000

  let s:_list = &list
  set nolist

  setlocal nonumber
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal cursorline
  setlocal nospell
  setlocal nobuflisted

  let s:running = 1
endfunction

" BEIgnoreBuffer 
function! s:BEIgnoreBuffer(buf)
  " Check to see if this buffer should be ignore by BufExplorer.

  " Skip temporary buffers with buftype set.
  if empty(getbufvar(a:buf, "&buftype") == 0)
    return 1
  endif

  " Skip unlisted buffers.
  if buflisted(a:buf) == 0
    return 1
  endif

  " Skip buffers with no name.
  if empty(bufname(a:buf)) == 1
    return 1
  endif

  " Do not add the BufExplorer window to the list.
  if fnamemodify(bufname(a:buf), ":t") == s:name
    call s:BEError("The buffer name was [".s:name."] so it was skipped.")
    return 1
  endif

  if index(s:MRU_Exclude_List, bufname(a:buf)) >= 0
    return 1
  end

  return 0 
endfunction

" BECleanup {{{1
function! s:BECleanup()
  if exists("s:_insertmode")|let &insertmode = s:_insertmode|endif
  if exists("s:_showcmd")   |let &showcmd    = s:_showcmd   |endif
  if exists("s:_cpo")       |let &cpo        = s:_cpo       |endif
  if exists("s:_report")    |let &report     = s:_report    |endif
  if exists("s:_list")      |let &list       = s:_list      |endif
  let s:running   = 0
  let s:splitMode = ""

  delmarks!
endfunction

" BufExplorerHorizontalSplit {{{1
function! BufExplorerHorizontalSplit()
  let s:splitMode = "sp"
  exec "BufExplorer"
endfunction

" BufExplorerVerticalSplit {{{1
function! BufExplorerVerticalSplit()
  let s:splitMode = "vsp"
  exec "BufExplorer"
endfunction

" StartBufExplorer {{{1
function! StartBufExplorer(open)
    let name = s:name

    if !has("win32")
        " On non-Windows boxes, escape the name so that is shows up correctly.
        let name = escape(name, "[]")
        "call s:BEError("Escaped")
    endif

    " Make sure there is only one explorer open at a time.
    if s:running == 1
        call s:BEError("WHAT THE 1")
        " Go to the open buffer.
        if has("gui")
            call s:BEError("WHAT THE 2")
            call s:BEError(name)
            exec "drop" name
        endif

        return
    endif

    " Add zero to ensure the variable is treated as a Number.
    let s:originBuffer = bufnr("%") + 0

    " Create or rebuild the raw buffer list if necessary.
    if !exists('s:raw_buffer_listing') || 
            \ empty(s:raw_buffer_listing) ||
            \ s:refreshBufferList == 1
        silent let s:raw_buffer_listing = s:BEGetBufferInfo(0)
    endif

    let copy = copy(s:raw_buffer_listing)

    if (g:bufExplorerShowUnlisted == 0)
        call filter(copy, 'v:val.attributes !~ "u"')
    endif

  " We may have to split the current window.
  if (s:splitMode != "")
    " Save off the original settings.
    let [_splitbelow, _splitright] = [&splitbelow, &splitright]

    " Set the setting to ours.
    let [&splitbelow, &splitright] = [g:bufExplorerSplitBelow, g:bufExplorerSplitRight]

    " Do it.
    exe 'keepalt '.s:splitMode

    " Restore the original settings.
    let [&splitbelow, &splitright] = [_splitbelow, _splitright]
  endif

  if !exists("b:displayMode") || b:displayMode != "winmanager"
    " Do not use keepalt when opening bufexplorer to allow the buffer that we are
    " leaving to become the new alternate buffer
    exec "silent keepjumps ".a:open." ".name
  endif

  call s:BEDisplayBufferList()
endfunction

" BEDisplayBufferList {{{1
function! s:BEDisplayBufferList()
  " Do not set bufhidden since it wipes out 
  " the data if we switch away from the buffer 
  " using CTRL-^
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap

  " Delete all previous lines to the black hole register
  call cursor(1,1)
  exec 'silent! normal! "_dG'

  call s:BESetupSyntax()
  call s:BEMapKeys()
  call setline(1, s:BECreateHelp())
  call s:BEBuildBufferList()
  call cursor(s:firstBufferLine, 1)

  if !g:bufExplorerResize
    normal! zz
  endif

  setlocal nomodifiable
endfunction

" BEMapKeys {{{1
function! s:BEMapKeys()
  if exists("b:displayMode") && b:displayMode == "winmanager"
    nnoremap <buffer> <silent> <tab> :call <SID>BESelectBuffer("tab")<cr>
  endif

  nnoremap <buffer> <silent> <F1>          :call <SID>BEToggleHelp()<cr>
  nnoremap <buffer> <silent> <2-leftmouse> :call <SID>BESelectBuffer()<cr>
  nnoremap <buffer> <silent> <cr>          :call <SID>BESelectBuffer()<cr>
  nnoremap <buffer> <silent> o             :call <SID>BESelectBuffer()<cr>
  nnoremap <buffer> <silent> t             :call <SID>BESelectBuffer("tab")<cr>
  nnoremap <buffer> <silent> <s-cr>        :call <SID>BESelectBuffer("tab")<cr>

  nnoremap <buffer> <silent> d             :call <SID>BERemoveBuffer("delete", "n")<cr>
  xnoremap <buffer> <silent> d             :call <SID>BERemoveBuffer("delete", "v")<cr>
  nnoremap <buffer> <silent> D             :call <SID>BERemoveBuffer("wipe", "n")<cr>
  xnoremap <buffer> <silent> D             :call <SID>BERemoveBuffer("wipe", "v")<cr>

  nnoremap <buffer> <silent> m             :call <SID>BEMRUListShow()<cr>
  nnoremap <buffer> <silent> p             :call <SID>BEToggleSplitOutPathName()<cr>
  nnoremap <buffer> <silent> q             :call <SID>BEClose("quit")<cr>
  nnoremap <buffer> <silent> r             :call <SID>BESortReverse()<cr>
  nnoremap <buffer> <silent> R             :call <SID>BEToggleShowRelativePath()<cr>
  nnoremap <buffer> <silent> s             :call <SID>BESortSelect()<cr>
  nnoremap <buffer> <silent> S             :call <SID>BEReverseSortSelect()<cr>
  nnoremap <buffer> <silent> u             :call <SID>BEToggleShowUnlisted()<cr>
  nnoremap <buffer> <silent> f             :call <SID>BEToggleFindActive()<cr>
  nnoremap <buffer> <silent> T             :call <SID>BEToggleShowTabBuffer()<cr>
  nnoremap <buffer> <silent> B             :call <SID>BEToggleOnlyOneTab()<cr>

  for k in ["G", "n", "N", "L", "M", "H"]
    exec "nnoremap <buffer> <silent>" k ":keepjumps normal!" k."<cr>"
  endfor
endfunction

" BESetupSyntax {{{1
function! s:BESetupSyntax()
  if has("syntax")
    syn match bufExplorerHelp         "^\".*" contains=bufExplorerSortBy,bufExplorerMapping,bufExplorerTitle,bufExplorerSortType,bufExplorerToggleSplit,bufExplorerToggleOpen
    syn match bufExplorerOpenIn       "Open in \w\+ window" contained
    syn match bufExplorerSplit        "\w\+ split" contained
    syn match bufExplorerSortBy       "Sorted by .*" contained contains=bufExplorerOpenIn,bufExplorerSplit
    syn match bufExplorerMapping      "\" \zs.\+\ze :" contained
    syn match bufExplorerTitle        "Buffer Explorer.*" contained
    syn match bufExplorerSortType     "'\w\{-}'" contained
    syn match bufExplorerBufNbr       /^\s*\d\+/
    syn match bufExplorerToggleSplit  "toggle split type" contained
    syn match bufExplorerToggleOpen   "toggle open mode" contained
    syn match bufExplorerModBuf       /^\s*\d\+.\{4}+.*/
    syn match bufExplorerLockedBuf    /^\s*\d\+.\{3}[\-=].*/
    syn match bufExplorerHidBuf       /^\s*\d\+.\{2}h.*/
    syn match bufExplorerActBuf       /^\s*\d\+.\{2}a.*/
    syn match bufExplorerCurBuf       /^\s*\d\+.%.*/
    syn match bufExplorerAltBuf       /^\s*\d\+.#.*/
    syn match bufExplorerUnlBuf       /^\s*\d\+u.*/

    hi def link bufExplorerBufNbr Number
    hi def link bufExplorerMapping NonText
    hi def link bufExplorerHelp Special
    hi def link bufExplorerOpenIn Identifier
    hi def link bufExplorerSortBy String
    hi def link bufExplorerSplit NonText
    hi def link bufExplorerTitle NonText
    hi def link bufExplorerSortType bufExplorerSortBy
    hi def link bufExplorerToggleSplit bufExplorerSplit
    hi def link bufExplorerToggleOpen bufExplorerOpenIn

    hi def link bufExplorerActBuf Identifier
    hi def link bufExplorerAltBuf String
    hi def link bufExplorerCurBuf Type
    hi def link bufExplorerHidBuf Constant
    hi def link bufExplorerLockedBuf Special
    hi def link bufExplorerModBuf Exception
    hi def link bufExplorerUnlBuf Comment
  endif
endfunction

" BEToggleHelp {{{1
function! s:BEToggleHelp()
  let g:bufExplorerDetailedHelp = !g:bufExplorerDetailedHelp

  setlocal modifiable

  " Save position.
  normal! ma

  " Remove old header.
  if (s:firstBufferLine > 1)
    exec "keepjumps 1,".(s:firstBufferLine - 1) "d _"
  endif

  call append(0, s:BECreateHelp())

  silent! normal! g`a
  delmarks a

  setlocal nomodifiable

  if exists("b:displayMode") && b:displayMode == "winmanager"
    call WinManagerForceReSize("BufExplorer")
  endif
endfunction

" BEGetHelpStatus {{{1
function! s:BEGetHelpStatus()
  let ret = '" Sorted by '.((g:bufExplorerReverseSort == 1) ? "reverse " : "").g:bufExplorerSortBy
  let ret .= ' | '.((g:bufExplorerFindActive == 0) ? "Don't " : "")."Locate buffer"
  let ret .= ((g:bufExplorerShowUnlisted == 0) ? "" : " | Show unlisted")
  let ret .= ((g:bufExplorerShowTabBuffer == 0) ? "" : " | Show buffers/tab")
  let ret .= ((g:bufExplorerOnlyOneTab == 1) ? "" : " | One tab / buffer")
  let ret .= ' | '.((g:bufExplorerShowRelativePath == 0) ? "Absolute" : "Relative")
  let ret .= ' '.((g:bufExplorerSplitOutPathName == 0) ? "Full" : "Split")." path"

  return ret
endfunction

" BECreateHelp {{{1
function! s:BECreateHelp()
  if g:bufExplorerDefaultHelp == 0 && g:bufExplorerDetailedHelp == 0
    let s:firstBufferLine = 1
    return []
  endif

  let header = []

  if g:bufExplorerDetailedHelp == 1
    call add(header, '" Buffer Explorer ('.g:bufexplorer_version.')')
    call add(header, '" --------------------------')
    call add(header, '" <F1> : toggle this help')
    call add(header, '" <enter> or o or Mouse-Double-Click : open buffer under cursor')
    call add(header, '" <shift-enter> or t : open buffer in another tab')
    call add(header, '" d : delete buffer')
    call add(header, '" D : wipe buffer')
    call add(header, '" f : toggle find active buffer')
    call add(header, '" p : toggle spliting of file and path name')
    call add(header, '" q : quit')
    call add(header, '" r : reverse sort')
    call add(header, '" R : toggle showing relative or full paths')
    call add(header, '" s : cycle thru "sort by" fields '.string(s:sort_by).'')
    call add(header, '" S : reverse cycle thru "sort by" fields')
    call add(header, '" T : toggle if to show only buffers for this tab or not')
    call add(header, '" u : toggle showing unlisted buffers')
  else
    call add(header, '" Press <F1> for Help')
  endif

  if (!exists("b:displayMode") || b:displayMode != "winmanager") || (b:displayMode == "winmanager" && g:bufExplorerDetailedHelp == 1)
    call add(header, s:BEGetHelpStatus())
    call add(header, '"=')
  endif

  let s:firstBufferLine = len(header) + 1

  return header
endfunction

" BEGetBufferInfo {{{1
function! s:BEGetBufferInfo(bufnr)
  redir => bufoutput
  buffers!
  redir END

  if (a:bufnr > 0)
    " Since we are only interested in this specified buffer 
    " remove the other buffers listed
    let bufoutput = substitute(bufoutput."\n", '^.*\n\(\s*'.a:bufnr.'\>.\{-}\)\n.*', '\1', '')
  endif

  let [all, allwidths, listedwidths] = [[], {}, {}]

  for n in keys(s:types)
    let allwidths[n] = []
    let listedwidths[n] = []
  endfor

  for buf in split(bufoutput, '\n')
    let bits = split(buf, '"')
    let b = {"attributes": bits[0], "line": substitute(bits[2], '\s*', '', '')}

    for [key, val] in items(s:types)
      let b[key] = fnamemodify(bits[1], val)
    endfor

    if getftype(b.fullname) == "dir" && g:bufExplorerShowDirectories == 1
      let b.shortname = "<DIRECTORY>"
    endif

    call add(all, b)

    for n in keys(s:types)
      call add(allwidths[n], len(b[n]))

      if b.attributes !~ "u"
        call add(listedwidths[n], len(b[n]))
      endif
    endfor
  endfor

  let [s:allpads, s:listedpads] = [{}, {}]

  for n in keys(s:types)
    let s:allpads[n] = repeat(' ', max(allwidths[n]))
    let s:listedpads[n] = repeat(' ', max(listedwidths[n]))
  endfor

  let s:refreshBufferList = 1

  return all
endfunction

" BEBuildBufferList {{{1
function! s:BEBuildBufferList()
    let lines = []

    " Loop through every buffer.
    for buf in s:raw_buffer_listing
        " Skip unlisted buffers if we are not to show them.
        if (!g:bufExplorerShowUnlisted && buf.attributes =~ "u")
            continue
        endif

        if (g:bufExplorerShowTabBuffer)
            let show_buffer = 0

            for bufnr in s:tabSpace[tabpagenr()]
                if (buf.attributes =~ '^\s*'.bufnr.'\>')
                    " Only buffers shown on the current tabpagenr
                    let show_buffer = 1
                    break
                endif
            endfor

            if show_buffer == 0 
                continue
            endif
        endif

        let line = buf.attributes." "

        if g:bufExplorerSplitOutPathName
            let type = (g:bufExplorerShowRelativePath) ? "relativepath" : "path"
            let path = buf[type]
            let pad  = (g:bufExplorerShowUnlisted) ? s:allpads.shortname : s:listedpads.shortname
            let line .= buf.shortname." ".strpart(pad.path, len(buf.shortname))
        else
            let type = (g:bufExplorerShowRelativePath) ? "relativename" : "fullname"
            let path = buf[type]
            let line .= path
        endif

        let pads = (g:bufExplorerShowUnlisted) ? s:allpads : s:listedpads

        if !empty(pads[type])
            let line .= strpart(pads[type], len(path))." "
        endif

        let line .= buf.line

        call add(lines, line)
    endfor

    call setline(s:firstBufferLine, lines)

    call s:BESortListing()
endfunction

" BESelectBuffer {{{1
function! s:BESelectBuffer(...)
  " Sometimes messages are not cleared when we get here so it looks like an error has
  " occurred when it really has not.
  echo ""

  " Are we on a line with a file name?
  if line('.') < s:firstBufferLine
    exec "normal! \<cr>"
    return
  endif

  let _bufNbr = str2nr(getline('.'))

  " Check and see if we are running BE via WinManager.
  if exists("b:displayMode") && b:displayMode == "winmanager"
    let bufname = expand("#"._bufNbr.":p")

    if (a:0 == 1) && (a:1 == "tab")
      call WinManagerFileEdit(bufname, 1)
    else
      call WinManagerFileEdit(bufname, 0)
    endif
 
    return
  endif

  if bufexists(_bufNbr)
    if bufnr("#") == _bufNbr && !exists("g:bufExplorerChgWin")
      return s:BEClose("")
    endif

    " Are we suppose to open the selected buffer in a tab?
    if (a:0 == 1) && (a:1 == "tab")
      " Yes, we are to open the selected buffer in a tab.

      " Restore [BufExplorer] buffer.
      exec "keepjumps silent buffer!".s:originBuffer

      " Get the tab number where this buffer is located at.
      let tabNbr = s:BEGetTabNbr(_bufNbr)

      " Was the tab found?
      if tabNbr == 0
        " _bufNbr is not opened in any tabs. Open a new tab with the selected buffer in it.
        exec "999tab split +buffer" . _bufNbr
      else
        " The _bufNbr is already opened in tab, go to that tab.
        exec tabNbr . "tabnext"

        " Focus window.
        exec s:BEGetWinNbr(tabNbr, _bufNbr) . "wincmd w"
      endif
    else
        "No, the use did not ask to open the selected buffer in a tab.

        " Are we suppose to move to the tab where this active buffer is?
        if exists("g:bufExplorerChgWin")
 	        exe g:bufExplorerChgWin."wincmd w"
 	    elseif bufloaded(_bufNbr) && g:bufExplorerFindActive
            " Close the BE window.
            call s:BEClose("")

        " Get the tab number where this buffer is located at.
        let tabNbr = s:BEGetTabNbr(_bufNbr)

        " Was the tab found?
        if tabNbr != 0
          " The buffer is located in a tab. Go to that tab number.
          exec tabNbr . "tabnext"
        else
          " Nope, the buffer is not in a tab, simple switch to that buffer.
          let bufname = expand("#"._bufNbr.":p")
          exec bufname ? "drop ".escape(bufname, " ") : "buffer "._bufNbr
        endif
      endif

      " Switch to the buffer.
      exec "keepalt keepjumps silent b!" _bufNbr
    endif

    " Make the buffer 'listed' again.
    call setbufvar(_bufNbr, "&buflisted", "1")
 
 	" call any associated function references
 	" g:bufExplorerFuncRef may be an individual function reference
 	"                or it may be a list containing function references.
 	" It will ignore anything that's not a function reference.
 	" See  :help FuncRef  for more on function references.
 	if exists("g:BufExplorerFuncRef")
 	  if type(g:BufExplorerFuncRef) == 2
 	    keepj call g:BufExplorerFuncRef()
 	  elseif type(g:BufExplorerFuncRef) == 3
 	    for FncRef in g:BufExplorerFuncRef
 	      if type(FncRef) == 2
 		    keepj call FncRef()
 	      endif
 	    endfor
 	  endif
    endif
  else
    call s:BEError("Sorry, that buffer no longer exists, please select another")
    call s:BEDeleteBuffer(_bufNbr, "wipe")
  endif
endfunction

" BEDeleteBufferListing {{{1
function! s:BEDeleteBufferListing(buf)
    if exists('s:raw_buffer_listing') && !empty(s:raw_buffer_listing)
        " Delete the buffer from the raw buffer list.
        " Careful use of ' and " so we do not have to escape all the \'s
        " Regex: ^\s*\(10\|20\)\>
        "        ^ - Starting at the beginning of the string
        "        \s* - optional whitespace
        "        \(10\|20\) - either a 10 or a 20
        "        \> - end of word (so it can't make 100 or 201)
        call filter(s:raw_buffer_listing, "v:val.attributes !~ '".'^\s*\('.substitute(a:buf, ' ', '\\|', 'g').'\)\>'."'")
    endif
endfunction

" BERemoveBuffer {{{1
function! s:BERemoveBuffer(type, mode) range
    " Are we on a line with a file name?
    if line('.') < s:firstBufferLine
        return
    endif

    " These commands are to temporarily suspend the activity of winmanager.
    if exists("b:displayMode") && b:displayMode == "winmanager"
        call WinManagerSuspendAUs()
    endif

    let _bufNbrs = ''

    for lineNum in range(a:firstline, a:lastline)
        let line = getline(lineNum)

        if line =~ '^\s*\(\d\+\)'
            " Regex: ^\s*\(10\|20\)\>
            "        ^ - Starting at the beginning of the string
            "        \s* - optional whitespace
            "        \zs - start the match here
            "        \d\+ - any digits
            "        \> - end of word (so it can't make 100 or 201)
            let bufNbr = matchstr(line, '^\s*\zs\d\+\>')

            " Add 0 to bufNbr to ensure Vim treats it as a Number
            " for use with the getbufvar() function
            if bufNbr !~ '^\d\+$' || getbufvar(bufNbr+0, '&modified') != 0
                call s:BEError("Sorry, no write since last change for buffer ".bufNbr.", unable to delete")
            else
                let _bufNbrs = _bufNbrs . (_bufNbrs==''?'':' '). bufNbr 
            endif
        endif
    endfor

    " Okay, everything is good, delete or wipe the buffers.
    call s:BEDeleteBuffer(_bufNbrs, a:type)

    " Reactivate winmanager autocommand activity.
    if exists("b:displayMode") && b:displayMode == "winmanager"
        call WinManagerForceReSize("BufExplorer")
        call WinManagerResumeAUs()
    endif
endfunction

" BEDeleteBuffer {{{1
function! s:BEDeleteBuffer(bufNbr, mode)
    " This routine assumes that the buffer to be removed is on the current line.
    try
        if a:mode == "wipe"
            exe "bwipe" a:bufNbr
        else
            exe "bdelete" a:bufNbr
        endif

        setlocal modifiable

        " Remove each of the lines beginning with the buffer numbers we are removing
        " Regex: ^\s*\(10\|20\)\>
        "        ^ - Starting at the beginning of the string
        "        \s* - optional whitespace
        "        \(10\|20\) - either a 10 or a 20
        "        \> - end of word (so it can't make 100 or 201)
        exec 'silent! g/^\s*\('.substitute(a:bufNbr, ' ', '\\|', 'g').'\)\>/d_'

        setlocal nomodifiable

        call s:BEDeleteBufferListing(a:bufNbr)
    catch
        call s:BEError(v:exception)
    endtry
endfunction

" BEClose {{{1
function! s:BEClose(mode)
    " Get only the listed buffers.
    let listed = filter(copy(s:MRUList), "buflisted(v:val)")

    " If we needed to split the main window, close the split one.
"  if (s:splitMode)
"  if (s:splitMode != "")
    if (s:splitMode != "" && a:mode == "quit")
        exec "wincmd c"
    endif

    if len(listed) == 0
        exe "enew"
    else
        for b in reverse(listed[0:1])
            exec "keepjumps silent b ".b
        endfor
    endif
endfunction

" BEToggleSplitOutPathName {{{1
function! s:BEToggleSplitOutPathName()
    let g:bufExplorerSplitOutPathName = !g:bufExplorerSplitOutPathName
    call s:BERebuildBufferList()
    call s:BEUpdateHelpStatus()
endfunction

" BEToggleShowRelativePath {{{1
function! s:BEToggleShowRelativePath()
    let g:bufExplorerShowRelativePath = !g:bufExplorerShowRelativePath
    call s:BERebuildBufferList()
    call s:BEUpdateHelpStatus()
endfunction

" BEToggleShowUnlisted {{{1
function! s:BEToggleShowUnlisted()
    let g:bufExplorerShowUnlisted = !g:bufExplorerShowUnlisted
    let num_bufs = s:BERebuildBufferList(g:bufExplorerShowUnlisted == 0)
    call s:BEUpdateHelpStatus()
endfunction

" BEToggleFindActive {{{1
function! s:BEToggleFindActive()
    let g:bufExplorerFindActive = !g:bufExplorerFindActive
    call s:BEUpdateHelpStatus()
endfunction

" BEToggleShowTabBuffer {{{1
function! s:BEToggleShowTabBuffer()
    let g:bufExplorerShowTabBuffer = !g:bufExplorerShowTabBuffer
    call s:BEDisplayBufferList()
endfunction

" BEToggleOnlyOneTab {{{1
function! s:BEToggleOnlyOneTab()
    let g:bufExplorerOnlyOneTab = !g:bufExplorerOnlyOneTab
    call s:BEDisplayBufferList()
endfunction

" BERebuildBufferList {{{1
function! s:BERebuildBufferList(...)
    setlocal modifiable

    let curPos = getpos('.')

    if a:0
        " Clear the list first.
        exec "keepjumps ".s:firstBufferLine.',$d "_'
    endif

    let num_bufs = s:BEBuildBufferList()

    call setpos('.', curPos)

    setlocal nomodifiable

    return num_bufs
endfunction

" BEUpdateHelpStatus {{{1
function! s:BEUpdateHelpStatus()
    setlocal modifiable

    let text = s:BEGetHelpStatus()
    call setline(s:firstBufferLine - 2, text)

    setlocal nomodifiable
endfunction

" BEMRUCmp {{{1
function! s:BEMRUCmp(line1, line2)
    return index(s:MRUList, str2nr(a:line1)) - index(s:MRUList, str2nr(a:line2))
endfunction

" BESortReverse {{{1
function! s:BESortReverse()
    let g:bufExplorerReverseSort = !g:bufExplorerReverseSort
    call s:BEReSortListing()
endfunction

" BESortSelect {{{1
function! s:BESortSelect()
    let g:bufExplorerSortBy = get(s:sort_by, index(s:sort_by, g:bufExplorerSortBy) + 1, s:sort_by[0])
    call s:BEReSortListing()
endfunction

" BEReverseSortSelect {{{1
function! s:BEReverseSortSelect()
    let g:bufExplorerSortBy = get(s:sort_by, (index(s:sort_by, g:bufExplorerSortBy) + len(s:sort_by) - 1) % len(s:sort_by), s:sort_by[0])
    call s:BEReSortListing()
endfunction

" BEReSortListing {{{1
function! s:BEReSortListing()
    setlocal modifiable

    let curPos = getpos('.')

    call s:BESortListing()
    call s:BEUpdateHelpStatus()

    call setpos('.', curPos)

    setlocal nomodifiable
endfunction

" BESortListing {{{1
function! s:BESortListing()
  let sort = s:firstBufferLine.",$sort".((g:bufExplorerReverseSort == 1) ? "!": "")

  if g:bufExplorerSortBy == "number"
    " Easiest case.
    exec sort 'n'
  elseif g:bufExplorerSortBy == "name"
    if g:bufExplorerSplitOutPathName
      exec sort 'ir /\d.\{7}\zs\f\+\ze/'
    else
      exec sort 'ir /\zs[^\/\\]\+\ze\s*line/'
    endif
  elseif g:bufExplorerSortBy == "fullpath"
    if g:bufExplorerSplitOutPathName
      " Sort twice - first on the file name then on the path.
      exec sort 'ir /\d.\{7}\zs\f\+\ze/'
    endif

    exec sort 'ir /\zs\f\+\ze\s\+line/'
  elseif g:bufExplorerSortBy == "extension"
    exec sort 'ir /\.\zs\w\+\ze\s/'
  elseif g:bufExplorerSortBy == "mru"
    let l = getline(s:firstBufferLine, "$")

    call sort(l, "<SID>BEMRUCmp")

    if g:bufExplorerReverseSort
      call reverse(l)
    endif

    call setline(s:firstBufferLine, l)
  endif
endfunction

" BEMRUListShow {{{1
function! s:BEMRUListShow()
    echomsg "MRUList=".string(s:MRUList)
endfunction

" BEError {{{1
function! s:BEError(msg)
    echohl ErrorMsg | echo a:msg | echohl none
endfunction

" BEWarning {{{1
function! s:BEWarning(msg)
    echohl WarningMsg | echo a:msg | echohl none
endfunction

" GetTabNbr {{{1
function! s:BEGetTabNbr(bufNbr)
    " Searching buffer bufno, in tabs.
    for i in range(tabpagenr("$"))
        if index(tabpagebuflist(i + 1), a:bufNbr) != -1
            return i + 1
        endif
    endfor

    return 0
endfunction

" GetWinNbr" {{{1
function! s:BEGetWinNbr(tabNbr, bufNbr)
    " window number in tabpage.
    return index(tabpagebuflist(a:tabNbr), a:bufNbr) + 1
endfunction

" Winmanager Integration {{{1
let g:BufExplorer_title = "\[Buf\ List\]"
call s:BESet("g:bufExplorerResize", 1)
call s:BESet("g:bufExplorerMaxHeight", 25) " Handles dynamic resizing of the window.

" Function to start display. Set the mode to 'winmanager' for this buffer.
" This is to figure out how this plugin was called. In a standalone fashion
" or by winmanager.
function! BufExplorer_Start()
    let b:displayMode = "winmanager"
    call StartBufExplorer("e")
endfunction

" Returns whether the display is okay or not.
function! BufExplorer_IsValid()
    return 0
endfunction

" Handles dynamic refreshing of the window.
function! BufExplorer_Refresh()
    let b:displayMode = "winmanager"
    call StartBufExplorer("e")
endfunction

function! BufExplorer_ReSize()
  if !g:bufExplorerResize
    return
  endif

  let nlines = min([line("$"), g:bufExplorerMaxHeight])

  exe nlines." wincmd _"

  " The following lines restore the layout so that the last file line is also
  " the last window line. Sometimes, when a line is deleted, although the
  " window size is exactly equal to the number of lines in the file, some of
  " the lines are pushed up and we see some lagging '~'s.
  let pres = getpos(".")

  exe $

  let _scr = &scrolloff
  let &scrolloff = 0

  normal! z-

  let &scrolloff = _scr

  call setpos(".", pres)
endfunction

" Default values {{{1
call s:BESet("g:bufExplorerDefaultHelp", 1)           " Show default help?
call s:BESet("g:bufExplorerDetailedHelp", 0)          " Show detailed help?
call s:BESet("g:bufExplorerFindActive", 1)            " When selecting an active buffer, take you to the window where it is active?
call s:BESet("g:bufExplorerReverseSort", 0)           " sort reverse?
call s:BESet("g:bufExplorerShowDirectories", 1)       " (Dir's are added by commands like ':e .')
call s:BESet("g:bufExplorerShowRelativePath", 0)      " Show listings with relative or absolute paths?
call s:BESet("g:bufExplorerShowUnlisted", 0)          " Show unlisted buffers?
call s:BESet("g:bufExplorerSortBy", "mru")            " Sorting methods are in s:sort_by:
call s:BESet("g:bufExplorerSplitOutPathName", 1)      " Split out path and file name?
call s:BESet("g:bufExplorerSplitRight", &splitright)  " Should vertical splits be on the right or left of current window?
call s:BESet("g:bufExplorerSplitBelow", &splitbelow)  " Should horizontal splits be below or above current window?
call s:BESet("g:bufExplorerShowTabBuffer", 0)         " Show only buffer(s) for this tab?
call s:BESet("g:bufExplorerOnlyOneTab", 1)            " If ShowTabBuffer = 1, only store the most recent tab for this buffer.

" Global variables {{{1
call s:BEReset()
let s:running = 0
let s:sort_by = ["number", "name", "fullpath", "mru", "extension"]
let s:types = {"fullname": ':p', "path": ':p:h', "relativename": ':~:.', "relativepath": ':~:.:h', "shortname": ':t'}
let s:originBuffer = 0
let s:splitMode = ""
let s:name = '[BufExplorer]'
let s:refreshBufferList = 1
let s:MRU_Exclude_List = ["[BufExplorer]","__MRU_Files__"]
"1}}}

" vim:ft=vim foldmethod=marker sw=2
