"=============================================================================
"        File: wintagexplorer.vim
"      Author: Srinath Avadhanula (srinath@eecs.berkeley.edu)
" Last Change: Wed Apr 03 05:00 PM 2002 PST
"        Help: This file provides a simple interface to a tags file. The tags
"              are grouped according to the file they belong to and the user can
"              press <enter> while on a tag to open the tag in an adjacent
"              window.
"
"              This file shows the implementation of an explorer plugin add-in
"              to winmanager.vim. As explained in |winmanager-adding|, this
"              function basically has to expose various functions which
"              winmanager calls during its refresh-diplay cycle. In turn, it
"              uses the function WinManagerRileEdit() supplied by
"              winmanager.vim.

" See ":help winmanager" for additional details.
" ============================================================================


" "TagsExplorer" is the "name" under which this plugin "registers" itself.
" Registration means including a line like:
"    RegisterExplorers "TagsExplorer"
" in the .vimrc. Registration provides a way to let the user customize the
" layout of the various windows. When a explorer is released, the user needs
" to know this "name" to register the plugin. 
"
" The first thing this plugin does is decide upon a "title" for itself. This is
" the name of the buffer which winmanager will open for displaying the
" contents of this plugin. Note that this variable has to be of the form:
"    g:<ExplorerName>_title
" where <ExplorerName> = "TagsExplorer" for this plugin.
let g:TagsExplorer_title = "[Tag List]"

" variables to remember the last position of the user within the file.
let s:savedCursorRow = 1
let s:savedCursorCol = 1

" skip display the error message if no tags file in current directory.
if !exists('g:TagsExplorerSkipError')
	let g:TagsExplorerSkipError = 0
end
if !exists('g:saveTagsDisplay')
	let g:saveTagsDisplay = 1
end

function! TagsExplorer_IsPossible()
	if glob('tags') == '' && g:TagsExplorerSkipError && !exists('s:tagsDisplay')
		return 0
	end
	return 1
endfunction

" This is the function which winmanager calls the first time this plugin is
" displayed. Again, the rule for the name of this function is:
" <ExplorerName>_Start()
"
function! TagsExplorer_Start()
	let _showcmd = &showcmd

	setlocal bufhidden=delete
	setlocal buftype=nofile
	setlocal modifiable
	setlocal noswapfile
	setlocal nowrap
	setlocal nobuflisted

	set noshowcmd

	" set up some _really_ elementary syntax highlighting.
	if has("syntax") && !has("syntax_items") && exists("g:syntax_on")
		syn match TagsExplorerFileName	'^\S*$'   
		syn match TagsExplorerTagName	'^  \S*' 
		syn match TagsExplorerError   '^"\s\+Error:'
		syn match TagsExplorerVariable 'g:TagsExplorerSkipError'
		syn match TagsExplorerIgnore '"$'

		hi def link TagsExplorerFileName Special
		hi def link TagsExplorerTagName String
		hi def link TagsExplorerError Error
		hi def link TagsExplorerVariable Comment
		hi def link TagsExplorerIgnore Ignore
	end

	" set up the maps.
	nnoremap <buffer> <silent> <c-]> :call <SID>OpenTag(0)<cr>
	nnoremap <buffer> <silent> <cr> :call <SID>OpenTag(0)<cr>
	nnoremap <buffer> <silent> <tab> :call <SID>OpenTag(1)<cr>
  	nnoremap <buffer> <silent> <2-leftmouse> :call <SID>OpenTag(0)<cr>
	nnoremap <buffer> <silent> <space> za
	nnoremap <buffer> <silent> <c-^> <Nop>
	nnoremap <buffer> <silent> <F5> :call <SID>DisplayTagsFile()<cr>

	call <SID>StartTagsFileDisplay()
	
	" clean up.
	setlocal nomodified
	let &showcmd = _showcmd
	unlet! _showcmd
endfunction

function! <SID>StartTagsFileDisplay()

	" if the tags were previously displayed, then they would have been saved
	" in this script variable. Therefore, just paste the contents of that
	" variable and quit.
	" instead of using just one variable, create a hash from the complete path
	" of the tags file so that tag files from multiple directories can be
	" displayed and there is caching for each of them.
	let presHash = substitute(fnamemodify('tags', ':p'), '[^a-zA-Z0-9]', '_', 'g')
	let taghash = ''
	if exists('s:tagHash_'.presHash)
		let taghash = 's:tagHash_'.presHash
		let dirhash = 's:dirHash_'.presHash
		let viewhash = 's:viewHash_'.presHash

		let s:lastHash = presHash
	elseif glob('tags') == '' && exists('s:lastHash')
		let taghash = 's:tagHash_'.s:lastHash
		let dirhash = 's:dirHash_'.s:lastHash
		let viewhash = 's:viewHash_'.s:lastHash
	end

	if taghash != ''

		setlocal modifiable
		1,$d_
		exe 'put='.taghash
		1d_
		setlocal nomodified
		setlocal nomodifiable

		" revert to the last saved view.
		exe 'call s:LoadView('.viewhash.')'
		exe 'let s:TagsDirectory = '.dirhash
		
		let s:lastHash = presHash
		return

	end

	if glob('.vimtagsdisplay') != '' && g:saveTagsDisplay


		let presHash = substitute(getcwd().'\tags', '[^a-zA-Z0-9]', '_', 'g')
		let taghash = 's:tagHash_'.presHash
		let dirhash = 's:dirHash_'.presHash
		let viewhash = 's:viewHash_'.presHash

		setlocal modifiable
		1,$ d_
		read .vimtagsdisplay
		let _a = @a
		0
		call search('^\S')
		1,.-1 d_
		normal! ggVG"ay
		exe 'let '.taghash.' = @a'
		let @a = _a
		call s:FoldTags()
		0
		setlocal nomodified
		setlocal nomodifiable

		exe 'let s:TagsDirectory = getcwd()'
		exe 'let '.dirhash.' = getcwd()'	
		exe 'let '.viewhash.' = s:MkViewNoNestedFolds()'
		let s:lastHash = presHash

		return

	elseif glob('tags') != ''


		let s:lastHash = substitute(fnamemodify('tags', ':p'), '[^a-zA-Z0-9]', '_', 'g')
		
		call <SID>DisplayTagsFile()

	else

	   call <SID>DisplayError()
	   " setting this variable results in the next invokations of
	   " TagsExplorer_IsPossible() to return 0. this makes
	   " EditNextVisibleExplorer() skip displaying the tags file the next time
	   " <C-n> is pressed.
	   let g:TagsExplorerSkipError = 1
	   return
	
	end

endfunction


function! <SID>DisplayTagsFile()

	let _showcmd = &showcmd
	let _report = &report
	set noshowcmd
	set report=10000
	setlocal modifiable

	if glob('tags') == ''
		return
	end

	1,$ d_
	silent! read tags

	" remove the leading comment lines.
	silent! % g/^!_/de
	" delete the first blank line which happens because of read
	0 d
	" if this is an empty tags file, then quit.
	if line('$') < 1 || getline(1) =~ '^\s*$'
		return
	end

	let startTime = localtime()
	% call s:GroupTags()
	let sortEndTime = localtime()
	
	call s:FoldTags()
	0
	let foldEndTime = localtime()

	let presHash = substitute(fnamemodify('tags', ':p'), '[^a-zA-Z0-9]', '_', 'g')
	let taghash = 's:tagHash_'.presHash
	let dirhash = 's:dirHash_'.presHash
	let viewhash = 's:viewHash_'.presHash

	" for fast redraw if this plugin is closed and reopened...
	let _a = @a
	normal! ggVG"ay
	exe 'let '.taghash.' = @a'
	let s:tagsDisplay = @a

	if g:saveTagsDisplay
		if glob('.vimtagsdisplay') != ''
			silent! redir! > .vimtagsdisplay
		else
			silent! redir > .vimtagsdisplay
		end
		silent! echo @a
		redir END
	end
		
	let @a = _a

	" store the directory of the current tags file location.
	exe 'let '.dirhash.' = getcwd()'
	exe 'let s:TagsDirectory = '.dirhash
	exe 'let '.viewhash.' = s:MkViewNoNestedFolds()'
	
	setlocal nomodified
	setlocal nomodifiable
	let &showcmd = _showcmd
	let &report = _report

endfunction

function! <SID>DisplayError()

	setlocal modifiable

	1,$ d_

    put='Error:'
    put=''
    put='No Tags File Found in the current directory. Try reopening WManager in a'
    put='directory which contains a tags file.'
    put=''
    put='An easy way to do this is to switch to the file explorer plugin (using <c-n>),'
    put='navigate to that directory, press \"c\" while there in order to set the pwd, and'
    put='then switch back to this view using <c-n>.'
    put=''
    put='This error message will not be shown for the remainder of this vim session.'
    put='To have it not appear at all, set g:TagsExplorerSkipError to 1 in your .vimrc'

	1d
	let _tw= &tw
	let &tw = g:winManagerWidth - 2
	normal! ggVGgq
	% s/$/"/g
	0

	let &tw = _tw

	setlocal nomodifiable
	setlocal nomodified

endfunction

function! TagsExplorer_WrapUp()
	if !exists('s:lastHash')
		return
	end
	
	let viewhash = 's:viewHash_'.s:lastHash
	exe 'let '.viewhash.' = s:MkViewNoNestedFolds()'
endfunction

function! TagsExplorer_IsValid()
	return 1
endfunction

function! <SID>OpenTag(split)
	let line = getline('.')
	" if ther is a quote at the end of the line, it means we are still
	" displaying the error message. 
	if match(line, '"$') != -1
		return
	end

	normal! 0
	" this is a tag, because it starts with a space.
	let tag = ''
	if line =~ '^\s'
		let tag = matchstr(getline('.'), '  \zs.*\ze')
		" go back and extract the file name
		let num = line('.')
		?^\S
		normal! 0
		let fname = getline('.')
		exe num
	else
		let fname = getline('.')
	end
	let _pwd = getcwd()
	exe 'cd '.s:TagsDirectory
	call WinManagerFileEdit(fnamemodify(fname, ':p'), a:split)
	exe 'cd '._pwd

	if tag != '' 
		exe 'silent! tag '.tag
	end
endfunction

" function to group tags according to which file they belong to...
" does not use the "% g" command. does the %g command introduce a O(n^2)
" nature into the algo?
function! <SID>GroupTags() range
	" get the first file
	let numfiles = 0
	
	let linenum = a:firstline

	while linenum <= a:lastline
		
		" extract the filename and the tag name from this line. this is
		" another potential speed killer.
		let tagname = matchstr(getline(linenum), '^[^\t]*\t\@=')
		let fname = matchstr(getline(linenum), '\t\zs[^\t]*\ze')

		" create a hash with this name.
		" this is the costliest operation in this loop. if the file names are
		" fully qualified and some 50 characters long, this might take very
		" long. however, every line _has_ to be processed and therefore
		" something has to be done with the filename. the only question is,
		" how clever can we get with that operation?
		let fhashname = substitute(fname, '[^a-zA-Z0-9_]', '_', 'g')

		if !exists('hash_'.fhashname)
			exe 'let hash_'.fhashname.' = ""'
			let numfiles = numfiles + 1
			exe 'let filehash_'.numfiles.' = fhashname'
			exe 'let filename_'.numfiles.' = fname'
		end
		" append this tag to the tag list corresponding to this file name.
		exe 'let hash_'.fhashname.' = hash_'.fhashname.'."  ".tagname."\n"'
		
		let linenum = linenum + 1
	endwhile
	0
	1,$ d_
	
	let i = 1
	while i <= numfiles
		$
		exe 'let hashname = filehash_'.i
		exe 'let tagsf = hash_'.hashname
		exe 'let filename = filename_'.i
		let disp = filename."\n".tagsf

		put=disp

		let i = i + 1
	endwhile
	0 d_
endfunction

function! <SID>FoldTags()
	
	setlocal foldmethod=manual
	1
	let lastLine = 1
	while 1
		if search('^\S', 'W')
			normal! k
			let presLine = line('.')
		else
			break
		end
		exe lastLine.','.presLine.' fold'
		normal! j
		let lastLine = line('.')
	endwhile
	exe lastLine.',$ fold'
endfunction

function! TE_ShowVariableValue(...)
	let i = 1
	while i <= a:0
		exe 'let arg = a:'.i
		if exists('s:'.arg) ||
		\  exists('*s:'.arg)
			exe 'let val = s:'.arg
			echomsg 's:'.arg.' = '.val
		end
		let i = i + 1
	endwhile
endfunction

" Synopsis: let foldInfo = s:MkViewNoNestedFolds()
" Description: returns the view information. This function is to be used when
"    it is known that there are no nested folds in the file (i.e folds with
"    depth > 1). when there are nested folds, this function silently ignores
"    them.
function! s:MkViewNoNestedFolds()
	let row = line('.')
	let col = virtcol('.')
	let viewInfo = row.'#'.col.'#'
	let openInfo = ''

	let i = 1
	while i <= line('$')
		if foldlevel(i) > 0
			let unfold = 0
			if foldclosedend(i) < 0
				exe i
				normal! zc
				let unfold = 1
				let openInfo = openInfo.0.','
			else
				let openInfo = openInfo.1.','
			end
			let j = foldclosedend(i)
			let viewInfo  = viewInfo.i.','.j.'|'
			if unfold
				exe i
				normal! zo
			end
			let i = j + 1
			continue
		end
		let i = i + 1
	endwhile
	
	let viewInfo = viewInfo.'#'.openInfo
	let viewInfo = substitute(viewInfo, '|#', '#', '')
	let viewInfo = substitute(viewInfo, ',$', '', '')

	exe row
	exe 'normal! '.col.'|'

	return viewInfo
endfunction

" Synopsis: call s:LoadView(foldInfo)
" Description: This function restores the view defined in the argument
"    foldInfo. See the description of MkView() for the format of this
"    argument. This function should only be used when the foldmethod of the
"    file is manual. There is no error-checking done in this function, so it
"    needs to be used responsibly.
function! s:LoadView(foldInfo)
	let row = s:Strntok(a:foldInfo, '#', 1)
	let col = s:Strntok(a:foldInfo, '#', 2)
	let folds = s:Strntok(a:foldInfo, '#', 3)
	let fclosedinfo = s:Strntok(a:foldInfo, '#', 4)
	
	normal! zE

	let i = 1
	let foldi = s:Strntok(folds, '|', i)
	let isclosed = s:Strntok(fclosedinfo, ',', i)

	while foldi != ''
		let n1 = s:Strntok(foldi, ',', 1)
		let n2 = s:Strntok(foldi, ',', 2)
		exe n1.','.n2.' fold'

		if !isclosed
			exe n1
			normal! zo
		end

		let i = i + 1
		let foldi = s:Strntok(folds, '|', i)
		let isclosed = s:Strntok(fclosedinfo, ',', i)
	endwhile

	exe row
	exe 'normal! '.col.'|'
endfunction

" Strntok:
" extract the n^th token from s seperated by tok. 
" example: Strntok('1,23,3', ',', 2) = 23
fun! <SID>Strntok(s, tok, n)
	return matchstr( a:s.a:tok[0], '\v(\zs([^'.a:tok.']*)\ze['.a:tok.']){'.a:n.'}')
endfun
