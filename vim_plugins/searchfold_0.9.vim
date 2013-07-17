" Vim global plugin -- create folds based on last search pattern
" General: {{{1
" File:		searchfold.vim
" Created:	2008 Jan 19
" Last Change:	2011 May 24
" Rev Days:     18
" Author:	Andy Wokula <anwoku@yahoo.de>
" Credits:	Antonio Colombo's f.vim (Vimscript #318, 2005 May 10)
" Vim Version:	Vim 7.0
" Version:	0.9

" Description:
"   Provide mappings to fold away lines not matching the last search pattern
"   and to restore old fold settings afterwards.  Uses manual fold method,
"   which allows for nested folds to hide or show more context.  Doesn't
"   preserve the user's manual folds.

" Usage:
"   <Leader>z	fold away lines not matching the last search pattern.
"
"		With [count], change the initial foldlevel to ([count] minus
"		one).  The setting will be stored in g:searchfold_foldlevel
"		and will be reused when [count] is omitted.
"
"   <Leader>iz	fold away lines that do match the last search pattern
"		(inverse folding), also with [count].
"
"   <Leader>Z	restore the previous fold settings.
"
"		Minor Extra: If already in restored state, show a dialog to
"		revert all involved local fold options to the global
"		defaults.  The "(s)how" just prints info.

" Customization:
"   :let g:searchfold_maxdepth = 7
"		(number)
"		maximum fold depth
"
"   :let g:searchfold_usestep = 1
"		(boolean)
"		Controls how folds are organized: If 1 (default), each "zr"
"		(after "\z") unfolds the same amount of lines above and
"		below a match.  If 0, only one more line is unfolded above a
"		match.  This applies for next "\z" or "\iz".
"
"   :let g:searchfold_postZ_do_zv = 1
"		(boolean)
"		If 1, execute "zv" (view cursor line) after <Leader>Z.
"
"   :let g:searchfold_foldlevel = 0
"		(number)
"		Initial 'foldlevel' to set for <Leader>z and <Leader>iz.
"
"   :let g:searchfold_do_maps = 1
"		(boolean)
"		Whether to map the default keys or not.
"
" Hint: For boolean options, 1 actually means any non-zero number.

" Related:  Vimscript #158 (foldutil.vim) ... still to be checked out
"	    http://www.noah.org/wiki/Vim#Folding
"	    Vimscript #2302 (foldsearch.vim)
"	    Vimscript #578 (allfold.tar.gz)
"
" Changes:
"   v0.9    redraw removed, plug map renamed, comments (usestep ...)
"   v0.8    added inverse folding (<Leader>iz), g:searchfold_foldlevel,
"	    count for <Leader>z, <Plug> mappings, disabled F(), (fixes)
"   v0.7    b:searchfold fallback, s:foldtext check
"   v0.6    (after v0.4) added customization vars (usestep, maxdepth, Zpost)
"	    reverting global fold settings adds to cmd-history
"   v0.4    decreasing fold step always 1
"	    maxdepth 7 (before: 6)
"   v0.3    (after v0.1) added a modified F() from f.vim
"	    functions now with return values
"   v0.2    (skipped)

" Init Folklore: {{{1
if exists("loaded_searchfold")
    finish
endif
let loaded_searchfold = 1

if v:version<700
    echo "Searchfold: you need at least Vim 7.0"
    finish
endif

" Customization: {{{1
if !exists("g:searchfold_maxdepth")
    let g:searchfold_maxdepth = 7
endif
if !exists("g:searchfold_usestep")
    let g:searchfold_usestep = 1
endif
if !exists("g:searchfold_postZ_do_zv")
    let g:searchfold_postZ_do_zv = 1
endif
if !exists("g:searchfold_foldlevel")
    let g:searchfold_foldlevel = 0
endif
if !exists("g:searchfold_do_maps")
    let g:searchfold_do_maps = 1
endif

" s:variables {{{1
let s:foldtext = "(v:folddashes.'').((v:foldend)-(v:foldstart)+(1))"
" use unique notation of 'foldtext' to identify active searchfold in a
" window

func! s:FoldNested(from, to) " {{{1
    " create one fold from line a:from to line a:to, with more nested folds
    " return 1 if folds were created
    " return 0 if from > to
    let nlines = a:to - a:from
    if nlines < 0
	return 0
    elseif nlines < 3
	" range of 1 line possible
	exec a:from.",".a:to. "fold"
	return 1
    endif

    " calc folds, start with most outer fold
    " - range of inner folds at least 2 lines (from<to)
    " - limit nesting (depth)
    " - snap folds at start and end of file
    " - at greater "depth" (here depth->0), don't create folds with few
    "   lines only (check to-from>step)
    if g:searchfold_maxdepth < 1 || g:searchfold_maxdepth > 12
	let g:searchfold_maxdepth = 7
    endif
    let depth = g:searchfold_maxdepth
    let step = 1    " decstep:''
    let step1 = 1   " (const) decstep:'1'
    let from = a:from
    let to = a:to
    " let decstep = exists("g:searchfold_usestep") && g:searchfold_usestep ? "" : "1"
    let decstep = g:searchfold_usestep ? "" : "1"
    let foldranges = []
    let lined = line("$")
    while depth>0 && from<to && to-from>step
	call insert(foldranges, from.",".to)
	let from += from>1 ? step : 0
	" let to -= to<lined ? 1 : 0
	let to -= to<lined ? step{decstep} : 0
	let step += step    " arbitrary
	let depth -= 1
    endwhile

    " create folds, start with most inner fold
    for range in foldranges
	exec range. "fold"
    endfor

    return 1
endfunc

func! s:CreateFolds(inverse) " {{{1
    " create search folds for the whole buffer based on last search pattern
    let sav_cur = getpos(".")

    let matches = []	" list of lnums
    if !a:inverse
	global//call add(matches, line("."))
    else
	vglobal//call add(matches, line("."))
    endif

    let nmatches = len(matches)
    if nmatches > 0
	call s:FoldNested(1, matches[0]-1)
	let imax = nmatches - 1
	let i = 0
	while i < imax
	    if matches[i]+1 < matches[i+1]
		call s:FoldNested(matches[i]+1, matches[i+1]-1)
	    endif
	    let i += 1
	endwhile
	call s:FoldNested(matches[imax]+1, line("$"))
    endif

    let &l:foldlevel = g:searchfold_foldlevel
    call cursor(sav_cur[1:])

    return nmatches
endfunc

func! <sid>SearchFoldEnable(inverse) "{{{1
    " return number of matches
    if !search("", "n")
	" last search pattern not found, do nothing
	return 0
    endif
    if (!exists("w:searchfold") || w:searchfold.bufnr != bufnr(""))
	\ && &fdt != s:foldtext
	" remember settings
	let w:searchfold = { "bufnr": bufnr(""),
	    \ "fdm": &fdm,
	    \ "fdl": &fdl,
	    \ "fdt": &fdt,
	    \ "fen": &fen,
	    \ "fml": &fml }
	" else: do not remember settings if already enabled
    endif
    setlocal foldmethod=manual
    setlocal foldlevel=0
    let &l:foldtext=s:foldtext
    setlocal foldenable
    setlocal foldminlines=0
    normal! zE
    if exists("w:searchfold")
	let b:searchfold = w:searchfold
    endif
    return s:CreateFolds(a:inverse)
endfunc
func! SearchFoldRestore() "{{{1
    " turn off
    if exists("w:searchfold") && w:searchfold.bufnr == bufnr("")
	" restore settings; var has the right settings if exists, but
	" doesn't survive window split or win close/restore
	let &l:fdm = w:searchfold.fdm
	let &l:fdl = w:searchfold.fdl
	let &l:fdt = w:searchfold.fdt
	let &l:fen = w:searchfold.fen
	let &l:fml = w:searchfold.fml
	if &fdm == "manual"
	    " remove all search folds (old folds are lost anyway):
	    normal! zE
	endif
	unlet w:searchfold
    elseif exists("b:searchfold") && &fdt == s:foldtext
	" fallback only, may have wrong settings if overwritten
	let &l:fdm = b:searchfold.fdm
	let &l:fdl = b:searchfold.fdl
	let &l:fdt = b:searchfold.fdt
	let &l:fen = b:searchfold.fen
	let &l:fml = b:searchfold.fml
	if &fdm == "manual"
	    normal! zE
	endif
    else
	let choice = input("Revert to global fold settings? (y/[n]/(s)how):")[0]
	let setargs = 'fdm< fdl< fdt< fen< fml<'
	if choice == "y"
	    let cmd = 'setlocal '. setargs
	    echo ':'. cmd
	    exec cmd
	    " call histadd(':', cmd)
	elseif choice == "s"
	    let setargs = tr(setargs, "<","?")
	    let cmd = 'setglobal '. setargs
	    echo ':'. cmd
	    exec cmd
	    let cmd = 'setlocal '. setargs
	    echo ':'. cmd
	    exec cmd
	endif
	return
    endif
    if g:searchfold_postZ_do_zv
	normal! zv
    endif
endfunc

"" func! F() range "{{{1
"     " commented out 2010 Jun 01
"     " range arg: ignore range given by accident
"     let pat = input("Which regexp? ", @/)
"     if pat == ""
" 	if exists("w:searchfold")
" 	    call SearchFoldRestore()
" 	endif
" 	return
"     endif
"     let @/ = pat
"     call histadd("search", @/)
"     call SearchFold()
" endfunc

" :call F()	only for backwards compatibility

func! SearchFold(...) "{{{1
    let inverse = a:0>=1 && a:1
    if v:count >= 1
	let g:searchfold_foldlevel = v:count - 1
    endif
    let nmatches = <sid>SearchFoldEnable(inverse)
    " at most one match per line counted
    if nmatches == 0
	echohl ErrorMsg
	echomsg "Searchfold: Pattern not found:" @/
	echohl none
    elseif nmatches == line("$")
	echomsg "Searchfold: Pattern found in every line:" @/
    elseif nmatches == 1
	echo "Searchfold: 1 line found"
    else
	echo "Searchfold:" nmatches "lines found"
    endif
    " 2011 Feb 06 commented out:
    " let &hls = &hls
    " redraw
endfunc

" Mappings: {{{1
nn <silent> <Plug>SearchFoldNormal   :<C-U>call SearchFold(0)<CR>
nn <silent> <Plug>SearchFoldInverse  :<C-U>call SearchFold(1)<CR>
nn <silent> <Plug>SearchFoldRestore  :<C-U>call SearchFoldRestore()<CR>

if g:searchfold_do_maps
    nmap <Leader>z   <Plug>SearchFoldNormal
    nmap <Leader>iz  <Plug>SearchFoldInverse
    nmap <Leader>Z   <Plug>SearchFoldRestore
endif

" Modeline: {{{1
" vim:set fdm=marker ts=8 sts=4 sw=4 noet:
