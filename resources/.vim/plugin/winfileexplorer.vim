"=============================================================================
" File: explorer.vim
" Author: M A Aziz Ahmed (aziz@acorn-networks.com)
" Last Change: Sun Mar 31 11:00 PM 2002 PST
" Version: 2.5
" Additions by Mark Waggoner (waggoner@aracnet.com) et al.
"-----------------------------------------------------------------------------
" This file implements a file explorer. Latest version available at:
" http://www.freespeech.org/aziz/vim/
" Updated version available at:
" http://www.aracnet.com/~waggoner
"-----------------------------------------------------------------------------
" Normally, this file will reside in the plugins directory and be
" automatically sourced.  If not, you must manually source this file
" using :source explorer.vim
"
" To use it, just edit a directory (vi dirname) or type :Explore to
" launch the file explorer in the current window, or :Sexplore to split
" the current window and launch explorer there.
"
" If the current buffer is modified, the window is always split.
"
" It is also possible to delete files and rename files within explorer.
" See :help file-explorer for more details
"
"-----------------------------------------------------------------------------
" Update history removed, it's not very interesting.
" Contributors were: Doug Potts, Bram Moolenaar, Thomas Köhler
"
" This is a modified version to be compatible with winmanager.vim. 
" Changes by Srinath Avadhanula
"=============================================================================

" Has this already been loaded?
if exists("loaded_winfileexplorer")
  finish
endif
let loaded_winfileexplorer=1

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

"---
" Default settings for global configuration variables

" Split vertically instead of horizontally?
if !exists("g:explVertical")
  let g:explVertical=0
endif

" How big to make the window? Set to "" to avoid resizing
if !exists("g:explWinSize")
  let g:explWinSize=15
endif

" When opening a new file/directory, split below current window (or
" above)?  1 = below, 0 = to above
if !exists("g:explSplitBelow")
  let g:explSplitBelow = &splitbelow
endif

" Split to right of current window (or to left)?
" 1 = to right, 0 = to left
if !exists("g:explSplitRight")
  let g:explSplitRight = &splitright
endif

" Start the first explorer window...
" Defaults to be the same as explSplitBelow
if !exists("g:explStartBelow")
  let g:explStartBelow = g:explSplitBelow
endif

" Start the first explorer window...
" Defaults to be the same as explSplitRight
if !exists("g:explStartRight")
  let g:explStartRight = g:explSplitRight
endif

" Show detailed help?
if !exists("g:explDetailedHelp")
  let g:explDetailedHelp=0
endif

" Show file size and dates?
if !exists("g:explDetailedList")
  let g:explDetailedList=0
endif

" Format for the date
if !exists("g:explDateFormat")
  let g:explDateFormat="%d %b %Y %H:%M"
endif

" Files to hide
if !exists("g:explHideFiles")
  let g:explHideFiles=''
endif

" Field to sort by
if !exists("g:explSortBy")
  let g:explSortBy='name'
endif

" Segregate directories? 1, 0, or -1
if !exists("g:explDirsFirst")
  let g:explDirsFirst=1
endif

" Segregate items in suffixes option? 1, 0, or -1
if !exists("g:explSuffixesLast")
  let g:explSuffixesLast=1
endif

" Include separator lines between directories, files, and suffixes?
if !exists("g:explUseSeparators")
  let g:explUseSeparators=0
endif

" whether or not to take over the functioning of the default file-explorer
" plugin
if !exists("g:defaultExplorer")
	let g:defaultExplorer = 1
end

if !exists('g:favDirs')
	if exists('$HOME')
		let s:favDirs = expand('$HOME').'/'
	end
else
	if exists('$HOME')
		let s:favDirs = g:favDirs."\/\n".expand('$HOME')
	end
end
let s:favDirs = substitute(s:favDirs, '\', '/', 'g')
let s:favDirs = substitute(s:favDirs, '\/\/', '\/', 'g')

" -- stuff used by winmanager
let g:FileExplorer_title = "[File List]"
function! FileExplorer_Start()
	let b:displayMode = "winmanager"
	if exists('s:lastDirectoryDisplayed')
		call s:EditDir(s:lastDirectoryDisplayed)
	else
		call s:EditDir(expand("%:p:h"))
	end
	if exists('s:lastCursorRow')
		exe s:lastCursorRow
		exe 'normal! '.s:lastCursorColumn.'|'
	end
endfunction

function! FileExplorer_IsValid()
	return 1
endfunction

function! FileExplorer_WrapUp()
	let s:lastCursorRow = line('.')
	let s:lastCursorColumn = virtcol('.')
	let s:lastDirectoryDisplayed = b:completePath
endfunction
" --- end winmanager specific stuff (for now)

"---
" script variables - these are the same across all
" explorer windows

" characters that must be escaped for a regular expression
let s:escregexp = '/*^$.~\'

" characters that must be escaped for filenames
if has("dos16") || has("dos32") || has("win16") || has("win32") || has("os2")
  let s:escfilename = ' %#'
else
  let s:escfilename = ' \%#'
endif


" A line to use for separating sections
let s:separator='"---------------------------------------------------'

"---
" Create commands
" commenting stuff for beta version release
" if !exists(':Explore')
"   command -n=? -complete=dir Explore :call s:StartExplorer(0, '<a>')
" endif
" if !exists(':Sexplore')
"   command -n=? -complete=dir Sexplore :call s:StartExplorer(1, '<a>')
" endif
" 
"---
" Start the explorer using the preferences from the global variables
"
function! s:StartExplorer(split, start_dir)
	let startcmd = "edit"
	if a:start_dir != ""
		let fname=a:start_dir
	else
		let fname = expand("%:p:h")
	endif
	if fname == ""
		let fname = getcwd()
	endif

	" Create a variable to use if splitting vertically
	let splitMode = ""
	if g:explVertical == 1
		let splitMode = "vertical"
	endif

	" Save the user's settings for splitbelow and splitright
	let savesplitbelow = &splitbelow
	let savesplitright = &splitright

	if a:split || &modified
		let startcmd = splitMode . " " . g:explWinSize . "new " . fname
		let &splitbelow = g:explStartBelow
		let &splitright = g:explStartRight
	else
		let startcmd = "edit " . fname
	endif
	silent execute startcmd
	let &splitbelow = savesplitbelow
	let &splitright = savesplitright
endfunction


"---
" This is the main entry for 'editing' a directory
"
function! s:EditDir(...)
	" depending on the number of arguments, this function has either been called
	" by winmanager or by doing "e dirname" or :Explore
	if a:0 == 0
		" Get out of here right away if this isn't a directory!
		let name = expand("%")
		if name == ""
			let name = expand("%:p")
		endif
	elseif a:0 >= 1
		let name = a:1
		set modifiable
		1,$d_
	end	
	if a:0 >= 2 
		let forceReDisplay = a:2
	else
		let forceReDisplay = 0
	end

	if !isdirectory(name)
		return
	endif

	" Turn off the swapfile, set the buffer type so that it won't get
	" written, and so that it will get deleted when it gets hidden.
	setlocal modifiable
	setlocal noswapfile
	setlocal buftype=nowrite
	setlocal bufhidden=delete
	" Don't wrap around long lines
	setlocal nowrap


	" Get the complete path to the directory to look at with a slash at
	" the end
	let b:completePath = s:Path(name)
	let s:lastDirectoryDisplayed = b:completePath

	" Save the directory we are currently in and chdir to the directory
	" we are editing so that we can get a real path to the directory,
	" eliminating things like ".."
	let origdir= s:Path(getcwd())
	exe "chdir" escape(b:completePath,s:escfilename)
	let b:completePath = s:Path(getcwd())
	exe "chdir" escape(origdir,s:escfilename)

	" Add a slash at the end
	if b:completePath !~ '/$'
		let b:completePath = b:completePath . '/'
	endif

	" escape special characters for exec commands
	let b:completePathEsc=escape(b:completePath,s:escfilename)
	let b:parentDirEsc=substitute(b:completePathEsc, '/[^/]*/$', '/', 'g')

	" Set filter for hiding files
	let b:filterFormula=substitute(g:explHideFiles, '\([^\\]\),', '\1\\|', 'g')
	if b:filterFormula != ''
		let b:filtering="\nNot showing: " . b:filterFormula
	else
		let b:filtering=""
	endif


	" added to allow directory caching
	" s:numFileBuffers is an array containing the names of the directories
	" visited.
	if !exists("s:numFileBuffers")
		let s:numFileBuffers = 0
	end

	let i = 1
	while i <= s:numFileBuffers
		exec 'let diri = s:dir_'.i
		if diri == b:completePath
			" if we are on a previously displayed directory which is being redrawn
			" forcibly, then skip the stage of pasting from memory ... 
			if !forceReDisplay
				let oldRep=&report
				let save_sc = &sc
				set report=10000 nosc
				1,$d _
				exec 'put=s:FileList_'.i
				0d
				0
				let b:maxFileLen = 0
				/^"=/+1,$g/^/call s:MarkDirs()
				call s:CleanUpHistory()
				call s:PrintFavDirs()
				0
				/^"=/+1
				call s:CleanUpHistory()
				let &report=oldRep
				let &sc = save_sc
			end
			" ... merely remember the variable number and break.
			let s:currentFileNumberDisplayed = i
			break
		endif
		let i = i+1	
	endwhile

	" No need for any insertmode abbreviations, since we don't allow
	" insertions anyway!
	iabc <buffer>

	" Long or short listing?  Use the global variable the first time
	" explorer is called, after that use the script variable as set by
	" the interactive user.
	if exists("s:longlist")
		let w:longlist = s:longlist
	else
		let w:longlist = g:explDetailedList
	endif

	" Show keyboard shortcuts?
	if exists("s:longhelp")
		let w:longhelp = s:longhelp
	else
		let w:longhelp = g:explDetailedHelp
	endif

	" Set the sort based on the global variables the first time.  If you
	" later change the sort order, it will be retained in the s:sortby
	" variable for the next time you open explorer
	let w:sortdirection=1
	let w:sortdirlabel = ""
	let w:sorttype = ""
	if exists("s:sortby")
		let sortby=s:sortby
	else
		let sortby=g:explSortBy
	endif
	if sortby =~ "reverse"
		let w:sortdirection=-1
		let w:sortdirlabel = "reverse "
	endif
	if sortby =~ "date"
		let w:sorttype = "date"
	elseif sortby =~ "size"
		let w:sorttype = "size"
	else
		let w:sorttype = "name"
	endif
	call s:SetSuffixesLast()

	" Set up syntax highlighting
	" Something wrong with the evaluation of the conditional though...
	if has("syntax") && exists("g:syntax_on") && !has("syntax_items")
		syn match browseSynopsis    "^\"[ -].*"
		syn match favoriteDirectory "^+ .*$"
		syn match browseDirectory   "[^\"+].*/ "
		syn match browseDirectory   "[^\"+].*/$"
		syn match browseCurDir      "^\"= .*$"
		syn match browseSortBy      "^\" Sorted by .*$"  contains=browseSuffixInfo
		syn match browseSuffixInfo  "(.*)$"  contained
		syn match browseFilter      "^\" Not Showing:.*$"
		syn match browseFiletime    "«\d\+$"
		exec('syn match browseSuffixes    "' . b:suffixesHighlight . '"')

		"hi def link browseSynopsis    PreProc
		hi def link browseSynopsis    Special
		hi def link browseDirectory   Directory
		hi def link browseCurDir      Statement
		hi def link favoriteDirectory Type
		hi def link browseSortBy      String
		hi def link browseSuffixInfo  Type
		hi def link browseFilter      String
		hi def link browseFiletime    Ignore
		hi def link browseSuffixes    Type
	endif
	" Set up mappings for this buffer
	let cpo_save = &cpo
	set cpo&vim

	if exists("b:displayMode") && b:displayMode == "winmanager"
		" when called in winmanager mode, the argument movefirst assumes the role
		" of whether or not to split a window.
		nnoremap <buffer> <cr> :call <SID>EditEntry(0,"winmanager")<cr>
		nnoremap <buffer> <tab> :call <SID>EditEntry(1,"winmanager")<cr>
		nnoremap <buffer> -    :call <SID>EditDir(b:parentDirEsc)<cr>
		nnoremap <buffer> <2-leftmouse> :call <SID>EditEntry(0,"winmanager")<cr>
		nnoremap <buffer> C    :call <SID>EditDir(getcwd(),1)<cr>:call <SID>RestoreFileDisplay()<cr>
		nnoremap <buffer> <F5> :call <SID>EditDir(b:completePath,1)<cr>:call <SID>RestoreFileDisplay()<cr>
		nnoremap <buffer> <C-^> <Nop>
		nnoremap <buffer> f :call <SID>AddToFavDir()<cr>
	else
		nnoremap <buffer> <cr> :call <SID>EditEntry("","edit")<cr>
		nnoremap <buffer> -    :exec ("silent e "  . b:parentDirEsc)<cr>
		nnoremap <buffer> o    :call <SID>OpenEntry()<cr>
		nnoremap <buffer> O    :call <SID>OpenEntryPrevWindow()<cr>
		nnoremap <buffer> <2-leftmouse> :call <SID>DoubleClick()<cr>
	endif
	nnoremap <buffer> p   :call <SID>EditEntry("","pedit")<cr>
	nnoremap <buffer> a   :call <SID>ShowAllFiles()<cr>:call <SID>RestoreFileDisplay()<cr>
	nnoremap <buffer> R   :call <SID>RenameFile()<cr>
	nnoremap <buffer> D   :. call <SID>DeleteFile()<cr>:call <SID>RestoreFileDisplay()<cr>
	vnoremap <buffer> D   :call <SID>DeleteFile()<cr>:call <SID>RestoreFileDisplay()<cr>
	nnoremap <buffer> i   :call <SID>ToggleLongList()<cr>:call <SID>RestoreFileDisplay()<cr>
	nnoremap <buffer> s   :call <SID>SortSelect()<cr>:call <SID>RestoreFileDisplay()<cr>
	nnoremap <buffer> r   :call <SID>SortReverse()<cr>:call <SID>RestoreFileDisplay()<cr>
	nnoremap <buffer> ?   :call <SID>ToggleHelp()<cr>
	nnoremap <buffer> a   :call <SID>ShowAllFiles()<cr>:call <SID>RestoreFileDisplay()<cr>
	nnoremap <buffer> R   :call <SID>RenameFile()<cr>
	nnoremap <buffer> c   :exec "cd ".b:completePathEsc<cr>:pwd<cr>
	let &cpo = cpo_save

	" If directory is already loaded, don't open it again!
	if line('$') > 1
		setlocal nomodifiable
		return
	endif

	" Show the files
	call s:ShowDirectory()
	call s:PrintFavDirs()

	" prevent the buffer from being modified
	setlocal nomodifiable

	" remember the contents of this directory if its been displayed for the
	" first time for fast redraw later. if we have reached here bcause of a
	" forcible redraw, do not create a new s:dir_i variable.
	if !forceReDisplay
		let s:numFileBuffers = s:numFileBuffers + 1
		let s:currentFileNumberDisplayed = s:numFileBuffers
		exe 'let s:dir_'.s:currentFileNumberDisplayed.' = b:completePath'
	end
	0
	/^"=/+1
	call s:CleanUpHistory()
	call s:RestoreFileDisplay()
endfunction

"---
" If this is the only window, open file in a new window
" Otherwise, open file in the most recently visited window
"
function! s:OpenEntryPrevWindow()
	" Figure out if there are any other windows
	let n = winnr()
	wincmd p
	" No other window?  Then open a new one
	if n == winnr()
		call s:OpenEntry()
		" Other windows exist
	else
		" Check if the previous buffer is modified - ask if they want to
		" save!
		let bufname = bufname(winbufnr(winnr()))
		if &modified
			let action=confirm("Save Changes in " . bufname . "?","&Yes\n&No\n&Cancel")
			" Yes - try to save - if there is an error, cancel
			if action == 1
				let v:errmsg = ""
				silent w
				if v:errmsg != ""
					echoerr "Unable to write buffer!"
					wincmd p
					return
				endif
				" No, abandon changes
			elseif action == 2
				set nomodified
				echomsg "Warning, abandoning changes in " . bufname
				" Cancel (or any other result), don't do the open
			else
				wincmd p
				return
			endif
		endif
		wincmd p
		call s:EditEntry("wincmd p","edit")
	endif
endfunction

"
" save the contents of the currently displayed file listing into the current
" s:dir_i variable
"
function! s:RestoreFileDisplay()
	let oldRep=&report
	let save_sc = &sc
	set report=10000 nosc
	let presLine = line('.')

	let saverega = @a
	normal! ggVG"ay
	exec 'let s:FileList_'.s:currentFileNumberDisplayed.' = @a'
	let @a = saverega

	let &report=oldRep
	let &sc = save_sc
	exe presLine
endfunction

"---
" Open a file or directory in a new window.
" Use g:explSplitBelow and g:explSplitRight to decide where to put the
" split window, and resize the original explorer window if it is
" larger than g:explWinSize
"
function! s:OpenEntry()
  " Are we on a line with a file name?
  let l = getline(".")
  if l =~ '^"'
    return
  endif

  " Copy window settings to script settings
  let s:sortby=w:sortdirlabel . w:sorttype
  let s:longhelp = w:longhelp
  let s:longlist = w:longlist

  " Get the window number of the explorer window
  let n = winnr()

  " Save the user's settings for splitbelow and splitright
  let savesplitbelow=&splitbelow
  let savesplitright=&splitright

  " Figure out how to do the split based on the user's preferences.
  " We want to split to the (left,right,top,bottom) of the explorer
  " window, but we want to extract the screen real-estate from the
  " window next to the explorer if possible.
  "
  " 'there' will be set to a command to move from the split window
  " back to the explorer window
  "
  " 'back' will be set to a command to move from the explorer window
  " back to the newly split window
  "
  " 'right' and 'below' will be set to the settings needed for
  " splitbelow and splitright IF the explorer is the only window.
  "
  if g:explVertical
    if g:explSplitRight
      let there="wincmd h"
      let back ="wincmd l"
      let right=1
      let below=0
    else
      let there="wincmd l"
      let back ="wincmd h"
      let right=0
      let below=0
    endif
  else
    if g:explSplitBelow
      let there="wincmd k"
      let back ="wincmd j"
      let right=0
      let below=1
    else
      let there="wincmd j"
      let back ="wincmd k"
      let right=0
      let below=0
    endif
  endif

  " Get the file name
  let fn=s:GetFullFileName()

  " Attempt to go to adjacent window
  exec(back)
  " If no adjacent window, set splitright and splitbelow appropriately
  if n == winnr()
    let &splitright=right
    let &splitbelow=below
  else
    " found adjacent window - invert split direction
    let &splitright=!right
    let &splitbelow=!below
  endif

  " Create a variable to use if splitting vertically
  let splitMode = ""
  if g:explVertical == 1
    let splitMode = "vertical"
  endif

  " Is it a directory?  If so, get a real path to it instead of
  " relative path
  if isdirectory(fn)
    let origdir= s:Path(getcwd())
    exe "chdir" escape(fn,s:escfilename)
    let fn = s:Path(getcwd())
    exe "chdir" escape(origdir,s:escfilename)
  endif

  " Open the new window
  exec("silent " . splitMode." sp " . escape(fn,s:escfilename))

  " resize the explorer window if it is larger than the requested size
  exec(there)
  if g:explWinSize =~ '[0-9]\+' && winheight("") > g:explWinSize
    exec("silent ".splitMode." resize ".g:explWinSize)
  endif
  exec(back)

  " Restore splitmode settings
  let &splitbelow=savesplitbelow
  let &splitright=savesplitright

endfunction

"---
" Double click with the mouse
"
function s:DoubleClick()
	if expand("<cfile>") =~ '[\\/]$'
		call s:EditEntry("","edit")		" directory: open in this window
	else
		call s:OpenEntryPrevWindow()	" file: open in another window
	endif
endfun

"---
" Open file or directory in the same window as the explorer is
" currently in
"
function! s:EditEntry(movefirst,editcmd)
  " Are we on a line with a file name?
  let l = getline(".")
  if l =~ '^"'
    return
  endif

  " Copy window settings to script settings
  let s:sortby=w:sortdirlabel . w:sorttype
  let s:longhelp = w:longhelp
  let s:longlist = w:longlist

  " Get the file name
  let fn=s:GetFullFileName()
  if isdirectory(fn)
    let origdir= s:Path(getcwd())
    exe "chdir" escape(fn,s:escfilename)
    let fn = s:Path(getcwd())
    exe "chdir" escape(origdir,s:escfilename)
  endif

	" if its the original explorer using this function, then proceed as before.
	if !(exists("b:displayMode") && b:displayMode == "winmanager")
		" Move to desired window if needed
		exec(a:movefirst)
		" Edit the file/dir
		exec(a:editcmd . " " . escape(fn,s:escfilename))
	" otherwise if its winmanager which called it, then do things the winmanager
	" way, i.e, open directories in the same buffer and open files in the last
	" visited file editing area (splitting if necessary)
	else
		if isdirectory(fn)
			" callinng EditDir ensures that things are displayed in the same buffer.
			call s:EditDir(fn)
		else
			" this function is provided by winmanager. it takes focus to the last
			" visited buffer in the file editing area and then opens the new file in
			" its place, while taking into consideration whether that buffer was
			" modified, or whether the user wants to force a split each time, etc.
			call WinManagerFileEdit(fn, a:movefirst)
		end
	end
endfunction

"---
" Create a regular expression out of the suffixes option for sorting
" and set a string to indicate whether we are sorting with the
" suffixes at the end (or the beginning)
"
function! s:SetSuffixesLast()
	let b:suffixesRegexp = '\(' . substitute(escape(&suffixes,s:escregexp),',','\\|','g') . '\)$'
	let b:suffixesHighlight = '^[^"].*\(' . substitute(escape(&suffixes,s:escregexp),',','\\|','g') . '\)\( \|$\)'
	if has("fname_case")
		let b:suffixesRegexp = '\C' . b:suffixesRegexp
		let b:suffixesHighlight = '\C' . b:suffixesHighlight
	else
		let b:suffixesRegexp = '\c' . b:suffixesRegexp
		let b:suffixesHighlight = '\c' . b:suffixesHighlight
	endif
	if g:explSuffixesLast > 0 && &suffixes != ""
		let b:suffixeslast=" (" . &suffixes . " at end of list)"
	elseif g:explSuffixesLast < 0 && &suffixes != ""
		let b:suffixeslast=" (" . &suffixes . " at start of list)"
	else
		let b:suffixeslast=" ('suffixes' mixed with files)"
	endif
endfunction

"---
" Show the header and contents of the directory
"
function! s:ShowDirectory()
	" Prevent a report of our actions from showing up
	let oldRep=&report
	let save_sc = &sc
	set report=10000 nosc

	"Delete all lines
	1,$d _

	" Add the header
	call s:AddHeader()
	$d _

	" Display the files

	" Get a list of all the files
	let files = s:Path(glob(b:completePath."*"))
	if files != "" && files !~ '\n$'
		let files = files . "\n"
	endif

	" Add the dot files now, making sure "." is not included!
	let files = files . substitute(s:Path(glob(b:completePath.".*")), "[^\n]*/./\\=\n", '' , '')
	if files != "" && files !~ '\n$'
		let files = files . "\n"
	endif

	" Are there any files left after filtering?
	if files != ""
		normal! mt
		put =files
		let b:maxFileLen = 0
		0
		/^"=/+1,$g/^/call s:MarkDirs()
		call s:CleanUpHistory()
		normal! `t
		call s:AddFileInfo()
	endif

	normal! zz

	" Move to first directory in the listing
	0
	/^"=/+1
	call s:CleanUpHistory()

	" Do the sort
	call s:SortListing("Loaded contents of ".b:completePath.". ")

	" Move to first directory in the listing
	0
	/^"=/+1
	call s:CleanUpHistory()

	let &report=oldRep
	let &sc = save_sc

endfunction

function! s:AddToFavDir()

	if s:favDirs !~ "\\(^\\|\n\\)".b:completePath."\\(\n\\|$\\)"
		let s:favDirs = s:favDirs."\n".b:completePath
	else
		return
	endif

	let pos = (line('.')+1).' | normal! '.virtcol('.').'|'
	call s:PrintFavDirs()
	exe pos
endfunction

"---
" Mark which items are directories - called once for each file name
" must be used only when size/date is not displayed
"
function! s:MarkDirs()
	let oldRep=&report
	set report=1000
	"Remove slashes if added
	s;/$;;e
	"Removes all the leading slashes and adds slashes at the end of directories
	s;^.*\\\([^\\]*\)$;\1;e
	s;^.*/\([^/]*\)$;\1;e
	"normal! ^
	let currLine=getline(".")
	if isdirectory(b:completePath . currLine)
		s;$;/;
		let fileLen=strlen(currLine)+1
	else
		let fileLen=strlen(currLine)
		if (b:filterFormula!="") && (currLine =~ b:filterFormula)
			" Don't show the file if it is to be filtered.
			d _
		endif
	endif
	if fileLen > b:maxFileLen
		let b:maxFileLen=fileLen
	endif
	let &report=oldRep
endfunction

"---
" Make sure a path has proper form
"
function! s:Path(p)
	if has("dos16") || has("dos32") || has("win16") || has("win32") || has("os2")
		return substitute(a:p,'\\','/','g')
	else
		return a:p
	endif
endfunction

"---
" Extract the file name from a line in several different forms
"
function! s:GetFullFileNameEsc()
    return s:EscapeFilename(s:GetFullFileName())
endfunction

function! s:GetFileNameEsc()
    return s:EscapeFilename(s:GetFileName())
endfunction

function! s:EscapeFilename(name)
    return escape(a:name,s:escfilename)
endfunction


function! s:GetFullFileName()
	if getline('.') =~ '+ '
		if match(getline('.'), '(.*)') > 0
			return matchstr(getline('.'), '(\zs.*\ze)')
		else
			return strpart(getline('.'), 2, 1000)
		endif
	endif
	return s:ExtractFullFileName(getline("."))
endfunction

function! s:GetFileName()
	return s:ExtractFileName(getline("."))
endfunction

function! s:ExtractFullFileName(line)
	let fn=s:ExtractFileName(a:line)
	if fn == '/'
		return b:completePath
	else
		return b:completePath . s:ExtractFileName(a:line)
	endif
endfunction

function! s:ExtractFileName(line)
	return substitute(strpart(a:line,0,b:maxFileLen),'\s\+$','','')
endfunction

"---
" Get the size of the file
function! s:ExtractFileSize(line)
	if (w:longlist==0)
		return getfsize(s:ExtractFileName(a:line))
	else
		return strpart(a:line,b:maxFileLen+2,b:maxFileSizeLen);
	endif
endfunction

"---
" Get the date of the file as a number
function! s:ExtractFileDate(line)
	if w:longlist==0
		return getftime(s:ExtractFileName(a:line))
	else
		return strpart(matchstr(strpart(a:line,b:maxFileLen+b:maxFileSizeLen+4),"«.*"),1) + 0
	endif
endfunction


"---
" Add the header with help information
"
function! s:AddHeader()
	let save_f=@f
	1
	if w:longhelp==1
		let @f="\" <enter> : open file or directory\n"
			\."\" o : open new window for file/directory\n"
			\."\" O : open file in previously visited window\n"
			\."\" p : preview the file\n"
			\."\" i : toggle size/date listing\n"
			\."\" s : select sort field    r : reverse sort\n"
			\."\" - : go up one level      c : cd to this dir\n"
			\."\" R : rename file          D : delete file\n"
			\."\" f : add current directory to favourites\n"
			\."\" :help file-explorer for detailed help\n"
	else
		let @f="\" Press ? for keyboard shortcuts\n"
	endif
	let @f=@f."\" Sorted by ".w:sortdirlabel.w:sorttype.b:suffixeslast.b:filtering."\n"
	let @f=@f."\"= ".b:completePath."\n"
	put! f
	let @f=save_f
endfunction

function! s:PrintFavDirs()
	if !exists('s:favDirs')
		return
	end
	setlocal modifiable
	0
	if search('^"=')
		exe  'silent! 1,'.line('.').' g/^+ .*$/d _'
	else
		call s:CleanUpHistory()
		setlocal nomodifiable nomodified
		return
	endif
	call s:CleanUpHistory()
	let favDirs = s:favDirs
	let favDirs = substitute(favDirs, "\\(^\\|\n\\)", '\1+ ', 'g')
	let favDirs = substitute(favDirs, '$', "\n", '')
	0
	call search('^"=')
	silent! put!=favDirs
	silent! g/^+ /s/\v^\+ (.*)\/([^\/]+\/=)$/+ \2 (\1\/\2)
	call s:CleanUpHistory()
	call s:CleanUpHistory()
	setlocal nomodifiable nomodified
endfunction

"---
" Show the size and date for each file
"
function! s:AddFileInfo()
	let save_sc = &sc
	set nosc

	" Mark our starting point
	normal! mt

	call s:RemoveSeparators()

	" Remove all info
	0
	/^"=/+1,$g/^/call setline(line("."),s:GetFileName())
	call s:CleanUpHistory()

	" Add info if requested
	if w:longlist==1
		" Add file size and calculate maximum length of file size field
		let b:maxFileSizeLen = 0
		0
		/^"=/+1,$g/^/let fn=s:GetFullFileName() |
			\let fileSize=getfsize(fn) |
			\let fileSizeLen=strlen(fileSize) |
			\if fileSizeLen > b:maxFileSizeLen |
			\   let b:maxFileSizeLen = fileSizeLen |
			\endif |
			\exec "normal! ".(b:maxFileLen-strlen(getline("."))+2)."A \<esc>" |
			\exec 's/$/'.fileSize.'/'
		call s:CleanUpHistory()

		" Right justify the file sizes and
		" add file modification date
		0
		/^"=/+1,$g/^/let fn=s:GetFullFileName() |
			\exec "normal! A \<esc>$b".(b:maxFileLen+b:maxFileSizeLen-strlen(getline("."))+3)."i \<esc>\"_x" |
			\exec 's/$/ '.escape(s:FileModDate(fn), '/').'/'
		call s:CleanUpHistory()
		setlocal nomodified
	endif

	call s:AddSeparators()

	" return to start
	normal! `t

	let &sc = save_sc
endfunction


"----
" Get the modification time for a file
"
function! s:FileModDate(name)
	let filetime=getftime(a:name)
	if filetime > 0
		return strftime(g:explDateFormat,filetime) . " «" . filetime
	else
		return ""
	endif
endfunction

"---
" Delete a file or files
"
function! s:DeleteFile() range
	let oldRep = &report
	let &report = 1000

	let filesDeleted = 0
	let stopDel = 0
	let delAll = 0
	let currLine = a:firstline
	let lastLine = a:lastline
	setlocal modifiable

	while ((currLine <= lastLine) && (stopDel==0))
		exec(currLine)
		let fileName=s:GetFullFileName()
		if isdirectory(fileName)
			echo fileName." : Directory deletion not supported yet"
			let currLine = currLine + 1
		else
			if delAll == 0
				let sure=input("Delete ".fileName." (y/n/a/q)? ")
				if sure=="a"
					let delAll = 1
				endif
			endif
			if (sure=="y") || (sure=="a")
				let success=delete(fileName)
				if success!=0
					exec (" ")
					echo "\nCannot delete ".fileName
					let currLine = currLine + 1
				else
					d _
					let filesDeleted = filesDeleted + 1
					let lastLine = lastLine - 1
				endif
			elseif sure=="q"
				let stopDel = 1
			elseif sure=="n"
				let currLine = currLine + 1
			endif
		endif
	endwhile
	echo "\n".filesDeleted." files deleted"
	let &report = oldRep
	setlocal nomodified
	setlocal nomodifiable
endfunction

"---
" Rename a file
"
function! s:RenameFile()
	let fileName=s:GetFullFileName()
	setlocal modifiable
	if isdirectory(fileName)
		echo "Directory renaming not supported yet"
	elseif filereadable(fileName)
		let altName=input("Rename ".fileName." to : ")
		echo " "
		if altName==""
			setlocal nomodifiable
			return
		endif
		let success=rename(fileName, b:completePath.altName)
		if success!=0
			echo "Cannot rename ".fileName. " to ".altName
		else
			echo "Renamed ".fileName." to ".altName
			let oldRep=&report
			set report=1000
			" e!
			" instead of generating a bufEnter event if we use e!, use EditDir. It
			" doesnt matter that EditDir() is called with more than 0 arguments
			" whether or not winmanager is active because at this location, we have
			" a buffer open anyway.
			call s:EditDir(b:completePath, 1)
			let &report=oldRep
		endif
	endif
	setlocal nomodified
	setlocal nomodifiable
	call s:RestoreFileDisplay()
endfunction

"---
" Toggle between short and long help
"
function! s:ToggleHelp()
	if exists("w:longhelp") && w:longhelp==0
		let w:longhelp=1
		let s:longhelp=1
	else
		let w:longhelp=0
		let s:longhelp=0
	endif
	" Allow modification
	setlocal modifiable
	call s:UpdateHeader()
	" Disallow modification
	setlocal nomodifiable
endfunction

"---
" Update the header
"
function! s:UpdateHeader()
	let oldRep=&report
	set report=10000
	" Save position
	normal! mt
	" Remove old header
	0
	1,/^"=/ d _
	call s:CleanUpHistory()
	" Add new header
	call s:AddHeader()
	" Go back where we came from if possible
	0
	if line("'t") != 0
		normal! `t
	endif

	let &report=oldRep
	setlocal nomodified
endfunction

"---
" Toggle long vs. short listing
"
function! s:ToggleLongList()
	setlocal modifiable
	if exists("w:longlist") && w:longlist==1
		let w:longlist=0
		let s:longlist=0
	else
		let w:longlist=1
		let s:longlist=1
	endif
	call s:AddFileInfo()
	setlocal nomodifiable
endfunction

"---
" Show all files - remove filtering
"
function! s:ShowAllFiles()
	setlocal modifiable
	let b:filterFormula=""
	let b:filtering=""
	call s:ShowDirectory()
	setlocal nomodifiable
endfunction

"---
" Figure out what section we are in
"
function! s:GetSection()
	let fn=s:GetFileName()
	let section="file"
	if fn =~ '/$'
		let section="directory"
	elseif fn =~ b:suffixesRegexp
		let section="suffixes"
	endif
	return section
endfunction

"---
" Remove section separators
"
function! s:RemoveSeparators()
  if !g:explUseSeparators
    return
  endif
  0
  silent! exec '/^"=/+1,$g/^' . s:separator . "/d _"
  call s:CleanUpHistory()
endfunction

"---
" Add section separators
"   between directories and files if they are separated
"   between files and 'suffixes' files if they are separated
function! s:AddSeparators()
  if !g:explUseSeparators
    return
  endif
  0
  /^"=/+1
  call s:CleanUpHistory()
  let lastsec=s:GetSection()
  +1
  .,$g/^/let sec=s:GetSection() |
               \if g:explDirsFirst != 0 && sec != lastsec &&
               \   (lastsec == "directory" || sec == "directory") |
               \  exec "normal! I" . s:separator . "\n\<esc>" |
               \elseif g:explSuffixesLast != 0 && sec != lastsec &&
               \   (lastsec == "suffixes" || sec == "suffixes") |
               \  exec "normal! I" . s:separator . "\n\<esc>" |
               \endif |
               \let lastsec=sec
endfunction

"---
" General string comparison function
"
function! s:StrCmp(line1, line2, direction)
	if a:line1 < a:line2
		return -a:direction
	elseif a:line1 > a:line2
		return a:direction
	else
		return 0
	endif
endfunction

"---
" Function for use with Sort(), to compare the file names
" Default sort is to put in alphabetical order, but with all directory
" names before all file names
"
function! s:FileNameCmp(line1, line2, direction)
	let f1=s:ExtractFileName(a:line1)
	let f2=s:ExtractFileName(a:line2)

	" Put directory names before file names
	if (g:explDirsFirst != 0) && (f1 =~ '\/$') && (f2 !~ '\/$')
		return -g:explDirsFirst
	elseif (g:explDirsFirst != 0) && (f1 !~ '\/$') && (f2 =~ '\/$')
		return g:explDirsFirst
	elseif (g:explSuffixesLast != 0) && (f1 =~ b:suffixesRegexp) && (f2 !~ b:suffixesRegexp)
		return g:explSuffixesLast
	elseif (g:explSuffixesLast != 0) && (f1 !~ b:suffixesRegexp) && (f2 =~ b:suffixesRegexp)
		return -g:explSuffixesLast
	else
		return s:StrCmp(f1,f2,a:direction)
	endif

endfunction

"---
" Function for use with Sort(), to compare the file modification dates
" Default sort is to put NEWEST files first.  Reverse will put oldest
" files first
"
function! s:FileDateCmp(line1, line2, direction)
	let f1=s:ExtractFileName(a:line1)
	let f2=s:ExtractFileName(a:line2)
	let t1=s:ExtractFileDate(a:line1)
	let t2=s:ExtractFileDate(a:line2)

	" Put directory names before file names
	if (g:explDirsFirst != 0) && (f1 =~ '\/$') && (f2 !~ '\/$')
		return -g:explDirsFirst
	elseif (g:explDirsFirst != 0) && (f1 !~ '\/$') && (f2 =~ '\/$')
		return g:explDirsFirst
	elseif (g:explSuffixesLast != 0) && (f1 =~ b:suffixesRegexp) && (f2 !~ b:suffixesRegexp)
		return g:explSuffixesLast
	elseif (g:explSuffixesLast != 0) && (f1 !~ b:suffixesRegexp) && (f2 =~ b:suffixesRegexp)
		return -g:explSuffixesLast
	elseif t1 > t2
		return -a:direction
	elseif t1 < t2
		return a:direction
	else
		return s:StrCmp(f1,f2,1)
	endif
endfunction

"---
" Function for use with Sort(), to compare the file sizes
" Default sort is to put largest files first.  Reverse will put
" smallest files first
"
function! s:FileSizeCmp(line1, line2, direction)
	let f1=s:ExtractFileName(a:line1)
	let f2=s:ExtractFileName(a:line2)
	let s1=s:ExtractFileSize(a:line1)
	let s2=s:ExtractFileSize(a:line2)

	if (g:explDirsFirst != 0) && (f1 =~ '\/$') && (f2 !~ '\/$')
		return -g:explDirsFirst
	elseif (g:explDirsFirst != 0) && (f1 !~ '\/$') && (f2 =~ '\/$')
		return g:explDirsFirst
	elseif (g:explSuffixesLast != 0) && (f1 =~ b:suffixesRegexp) && (f2 !~ b:suffixesRegexp)
		return g:explSuffixesLast
	elseif (g:explSuffixesLast != 0) && (f1 !~ b:suffixesRegexp) && (f2 =~ b:suffixesRegexp)
		return -g:explSuffixesLast
	elseif s1 > s2
		return -a:direction
	elseif s1 < s2
		return a:direction
	else
		return s:StrCmp(f1,f2,1)
	endif
endfunction

"---
" Sort lines.  SortR() is called recursively.
"
function! s:SortR(start, end, cmp, direction)

  " Bottom of the recursion if start reaches end
  if a:start >= a:end
    return
  endif
  "
  let partition = a:start - 1
  let middle = partition
  let partStr = getline((a:start + a:end) / 2)
  let i = a:start
  while (i <= a:end)
    let str = getline(i)
    exec "let result = " . a:cmp . "(str, partStr, " . a:direction . ")"
    if result <= 0
      " Need to put it before the partition.  Swap lines i and partition.
      let partition = partition + 1
      if result == 0
        let middle = partition
      endif
      if i != partition
        let str2 = getline(partition)
        call setline(i, str2)
        call setline(partition, str)
      endif
    endif
    let i = i + 1
  endwhile

  " Now we have a pointer to the "middle" element, as far as partitioning
  " goes, which could be anywhere before the partition.  Make sure it is at
  " the end of the partition.
  if middle != partition
	  let str = getline(middle)
	  let str2 = getline(partition)
	  call setline(middle, str2)
	  call setline(partition, str)
  endif
  call s:SortR(a:start, partition - 1, a:cmp,a:direction)
  call s:SortR(partition + 1, a:end, a:cmp,a:direction)
endfunction

"---
" To Sort a range of lines, pass the range to Sort() along with the name of a
" function that will compare two lines.
"
function! s:Sort(cmp,direction) range
	call s:SortR(a:firstline, a:lastline, a:cmp, a:direction)
endfunction

"---
" Reverse the current sort order
"
function! s:SortReverse()
	if exists("w:sortdirection") && w:sortdirection == -1
		let w:sortdirection = 1
		let w:sortdirlabel  = ""
	else
		let w:sortdirection = -1
		let w:sortdirlabel  = "reverse "
	endif
	let s:sortby=w:sortdirlabel . w:sorttype
	call s:SortListing("")
endfunction

"---
" Toggle through the different sort orders
"
function! s:SortSelect()
	" Select the next sort option
	if !exists("w:sorttype")
		let w:sorttype="name"
	elseif w:sorttype == "name"
		let w:sorttype="size"
	elseif w:sorttype == "size"
		let w:sorttype="date"
	else
		let w:sorttype="name"
	endif
	let s:sortby=w:sortdirlabel . w:sorttype
	call s:SortListing("")
endfunction

"---
" Sort the file listing
"
function! s:SortListing(msg)
    " Save the line we start on so we can go back there when done
    " sorting
    let startline = getline(".")
    let col=col(".")
    let lin=line(".")

    " Allow modification
    setlocal modifiable

    " Send a message about what we're doing
    " Don't really need this - it can cause hit return prompts
"   echo a:msg . "Sorting by" . w:sortdirlabel . w:sorttype

    " Create a regular expression out of the suffixes option in case
    " we need it.
    call s:SetSuffixesLast()

    " Remove section separators
    call s:RemoveSeparators()

    " Do the sort
    0
    if w:sorttype == "size"
      /^"=/+1,$call s:Sort("s:FileSizeCmp",w:sortdirection)
    elseif w:sorttype == "date"
      /^"=/+1,$call s:Sort("s:FileDateCmp",w:sortdirection)
    else
      /^"=/+1,$call s:Sort("s:FileNameCmp",w:sortdirection)
    endif
  	call s:CleanUpHistory()

    " Replace the header with updated information
    call s:UpdateHeader()

    " Restore section separators
    call s:AddSeparators()

    " Return to the position we started on
    0
    if search('\m^'.escape(startline,s:escregexp),'W') <= 0
      execute lin
    endif
    execute "normal!" col . "|"

    " Disallow modification
    setlocal nomodified
    setlocal nomodifiable

endfunction

if !g:defaultExplorer
	let loaded_explorer = 1
	"---
	" Create commands
	if !exists(':Explore')
		command -n=? -complete=dir Explore :call s:StartExplorer(0, '<a>')
	endif
	if !exists(':Sexplore')
		command -n=? -complete=dir Sexplore :call s:StartExplorer(1, '<a>')
	endif
	" NOTE: This is a special command NOT to be used by users. Its here for
	" communication between winmanager and explorer.vim. This command only works
	" if you are currently 'editing' a directory, in which case, you dont need
	" this anyway. USE AT YOUR OWN RISK.
	if !exists(':ExploreInCurrentWindow')
		command -n=? -complete=dir ExploreInCurrentWindow :call <SID>EditDir()
	endif
end

" CleanUpHistory
function! <SID>CleanUpHistory()
  call histdel("/", -1)
  let @/ = histget("/", -1)
endfunction

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save


" vim: ts=4:noet:sw=4
