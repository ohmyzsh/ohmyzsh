"=============================================================================
"        File: winmanager.vim
"      Author: Srinath Avadhanula (srinath@eecs.berkeley.edu)
" Last Change: Wed Apr 03 05:00 PM 2002 PST
"        Help: winmanager.vim is a plugin which implements a classical windows
"              type IDE in Vim-6.0.  When you open up a new file, simply type
"              in :WMToggle. This will start up the file explorer.
"
"
" NOTE:  Starting from winmanager-2.x you can add new plugins to winmanager
" and also customize the window layout in your .vimrc
"
" See ":help winmanager" for additional details.
" ============================================================================

" quit if the user doesnt want us or if we are already loaded.
if exists("loaded_winmanager")
	finish
end
let loaded_winmanager = 1

" width of the explorer windows 
if !exists("g:winManagerWidth")
	let g:winManagerWidth = 25
end

" whether to close winmanager if only explorer windows are visible.
if !exists("g:persistentBehaviour")
	let g:persistentBehaviour = 1
end

" default window layout
if !exists("g:winManagerWindowLayout")
	let g:winManagerWindowLayout = "FileExplorer,TagsExplorer|BufExplorer"
end

" use default explorer plugin which ships with vim.
if !exists("g:defaultExplorer")
	let g:defaultExplorer = 1
end

" commands
" toggling between the windows manager open or closed. this can also be used
" to start win manager.
if !exists(':WMToggle')
	command -nargs=0 WMToggle :silent call <SID>ToggleWindowsManager()
end

" WManager and WMclose still exist for backward compatibility, but their use
" is deprecated because WMToggle has the functionality of both of them.
if !exists(':WManager')
	command -nargs=0 WManager :silent call <SID>StartWindowsManager()
end
if !exists(':WMClose')
	command -nargs=0 WMClose :silent call <SID>CloseWindowsManager()
end
" command to go to either the first explorer window visible
if !exists(':FirstExplorerWindow')
	command -nargs=0 FirstExplorerWindow :silent call <SID>GotoExplorerWindow('1')
end
" command to go to either the last explorer window visible
if !exists(':BottomExplorerWindow')
	command -nargs=0 BottomExplorerWindow :silent call <SID>GotoExplorerWindow('$')
end

" this command is used internally by winmanager. shouldnt be of concern to the
" user.
if !exists(':WinManagerGotoNextInGroup')
	command -nargs=1 WinManagerGotoNextInGroup :silent call <SID>GotoNextExplorerInGroup(<args>)
end	
if !exists(':WinManagerGotoPrevInGroup')
	command -nargs=1 WinManagerGotoPrevInGroup :silent call <SID>GotoNextExplorerInGroup(<args>,-1)
end	

" nifty command for debugging. SVarValueWinManager 'MRUList' will echo the
" value of 's:MRUList' for instance. to be used for debugging winmanager.
" shouldn't be of interest to the user.
if !exists(':SVarValueWinManager')
	command -nargs=* SVarValueWinManager :call <SID>ShowVariableValue(<args>)
end

" characters that must be escaped for filenames
if has("dos16") || has("dos32") || has("win16") || has("win32") || has("os2")
	let s:escfilename = ' %#'
else
	let s:escfilename = ' \%#'
endif

" a quick way to "uncomment" all the debug print statements.
let g:debugWinManager = 1
let g:numRefs = 0

" initialization.
let s:numExplorerGroups = 0
let s:numExplorers = 0

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

"---
" this function creates a variable 
" s:explorerGroup_i
" for the i^th time it is called. This variable will be of the form
" s:explorerGroup_i = ",member1,member2,member3,"
"
" this provides a way to "group" various explorers into common groups, so that
" one of them will be visible at a time.
"
function! <SID>RegisterExplorerGroup()
	" g:winManagerWindowLayout is of the form
	" 'FileExplorer,TagsExplorer|BufExplorer'
	
	" begin extracting groups from the layout variable.
	let groupNum = 1
	while 1
		" if no more groups then break.	
		let curGroup = s:Strntok(g:winManagerWindowLayout, '|', groupNum)
		if curGroup == ''
			break
		end
		
		" otherwise extract the explorers belonging to this group and the
		" explorer ID's etc. also protect against the same explorer being put
		" in 2 groups.
		let grplist = ','
		let numlist = ','
		let curgn = s:numExplorerGroups + 1

		let i = 1
		while 1
			let name = s:Strntok(curGroup, ',', i)
			if name == ''
				break
			end
			" refuse to register an explorer twice, or if the explorer's title
			" doesnt exist.
			if exists('s:'.name.'_numberID') || !exists('g:'.name.'_title')
				if  !exists('g:'.name.'_title')
					if has('gui_running')
						call confirm(name." is registered as a plugin, but I cannot seem to find it anywhere.\n"
							\.'Make sure you have downloaded the relevant plugin or change the g:winManagerWindowLayout variable',
							\"&ok", 1, 'Warning')
					else
						echohl Error
						echomsg name." is registered as a plugin, but I cannot seem to find it anywhere."
							\.'Please make sure you have downloaded the relevant plugin'
						echohl None
					endif
				endif
				let i = i + 1
				continue
			end

			let s:numExplorers = s:numExplorers + 1
			let num = s:numExplorers

			exe 'let s:explorerName_'.num.' = name'

			let grplist = grplist.name.","
			let numlist = numlist.''.num.','

			" create variables of the form ExplorerName_<group/member/number>ID
			" which contains which group the explorer belongs to and its member
			" number within that group and also its number
			" this will create a variable of the form
			exe 'let s:'.name.'_groupID  = "'.curgn.'"'
			exe 'let s:'.name.'_memberID = "'.i.'"'
			exe 'let s:'.name.'_numberID = "'.num.'"'

			let i = i + 1
		endwhile
		if grplist == ','
			call PrintError('no explorers registered in this run')
			return
		end

		let s:numExplorerGroups = s:numExplorerGroups + 1

		exe 'let s:explorerGroup_'.curgn.' = grplist'
		exe 'let s:explorerGroupNums_'.curgn.' = numlist'
		exe 'let s:numMembers_'.curgn.' = a:0'

		let groupNum = groupNum + 1
	endwhile

endfunction


"---
" initializes the window manager. sets the initial layout. as of now, the
" layout of the explorer windows (i.e, which plugin appears above or below the
" other) depends on the order in which the plugins are sourced. 
" TODO: make this easily user customizable later.
"       Done! See comments about registration.
"
" this function opens each "registered" plugin in its appropriate position. it
" also starts off the autocommand which makes dynamic updating of buffers
" possible.
"
function! <SID>StartWindowsManager()
	" for the first few versions of winmanager, if no registration is done,
	" assume the following default configuration of the windows:
	"    (FileExplorer, TagsExplorer)
	"    (BufExplorer)
	" This allows for an "easy" distribution. i.e, the installation will not
	" break if the user is careless with his .vimrc
	let oldRep=&report
	let save_sc = &sc
	set report=10000 nosc
	if s:numExplorers == 0
		call s:RegisterExplorerGroup()
	end
	let nothingShown = 1
	let s:commandRunning = 1

	if !exists("s:MRUList")
		call s:InitializeMRUList()
	end
	let currentWindowNumber = winnr()

	if !exists("s:gotExplorerTitles")
		let s:gotExplorerTitles = 1
		let i = 1
		while i <= s:numExplorers
			exe 'let name = s:explorerName_'.i
			exe 'let s:explorerTitle_'.i.' = g:'.name.'_title'
			let i = i + 1
		endwhile
	endif

	" focus on the first visible explorer window.
	let gotvisible = 0
	let i = 1
	while i <= s:numExplorerGroups
		" check if the ith explorer is visible.
		let windownum = s:IsExplorerGroupVisible(i)
		if windownum != -1
			call s:GotoWindow(windownum)
			let gotvisible = 1
			" cen is the "current explorer number". used while restoring the
			" layout.
			let cen = i
			let nothingShown = 0
			break
		end
		let i = i + 1
	endwhile

	" split the current window or vsplit a new window for the explorers if
	" none of the explorers is visible.
	if !gotvisible
		if exists('s:lastMemberDisplayed_1')
			let lastmem = s:lastMemberDisplayed_1
		else
			let lastmem = 1
		end
		let somethingDisplayed = s:EditNextVisibleExplorer(1, lastmem-1, 1, 'vsplit')
		" if nothing was displayed this time, there is a possiblity it could
		" happen later during one of the refresh cycles. remember this for
		" then.
		call PrintError('something displayed on '.lastmem.' of 1 :'.somethingDisplayed)
		if !somethingDisplayed
			let s:tryGroupAgain_1 = 1
			q
		else
			let s:tryGroupAgain_1 = 0
			let nothingShown = 0
			let currentWindowNumber = currentWindowNumber + 1
		end
		let cen = 1
		" for now assume that the explorer windows always stay on the left.
		" TODO: make this optional later
		wincmd H
		" set up the correct width
		exe g:winManagerWidth.'wincmd |'
	end

	" now we are on one of the explorers. time to redo the original layout.
	let _split = &splitbelow
	let i = 1
	while i <= s:numExplorerGroups
		" for each group, see if any member of it is visible.
		let windownum = s:IsExplorerGroupVisible(i)
		
		" if this explorer group is not visible, then open the first plugin
		" belonging to this group
		if windownum == -1

			" if this explorer group is "before" the cen, then split above, else
			" below. except for the first time when this could possibly be
			" true, it always evaluates to the else.
			if i < cen
				set nosplitbelow
			else
				set splitbelow
			end
			" find the last plugin belonging to this "group" which was
			" displayed.
			if exists('s:lastMemberDisplayed_'.i)
				exe 'let lastmem = s:lastMemberDisplayed_'.i
			else
				let lastmem = 1
			end
			" try to display either that plugin or the one after it.
			let somethingDisplayed = s:EditNextVisibleExplorer(i, lastmem-1,1,"split")
			if !somethingDisplayed
				exe 'let s:tryGroupAgain_'.i.' = 1'
				q
			else
				exe 'let s:tryGroupAgain_'.i.' = 0'
				" if this is the first explorer shown, need to push it to the
				" right.
				if nothingShown
					wincmd H
					" set up the correct width
					exe g:winManagerWidth.'wincmd |'
				end
				let nothingShown = 0
				let currentWindowNumber = currentWindowNumber + 1
			end
			let cen = i

		" the group is visible, go to it so we can split the one after that
		" from it.
		else
			call s:GotoWindow(windownum)
		endif

		let i = i + 1
		" cen: current explorer (group) number which was visited.
		let cen = i
	endwhile
	call PrintError('done with start while loop')
	
	" now make the run for resizing. 
	let i = 1
	while i <= s:numExplorerGroups
		" find if its visible and the explorer of this group which is
		" currently displayed.
		let windownum = s:IsExplorerGroupVisible(i)
		" need to check because some of the explorer groups might not have
		" been displayed, if all their members were unable to display
		" anything.
		if windownum == -1
			let i = i + 1
			continue
		end
		let numexp = s:WhichMemberVisible(i)
		
		" visible, goto that window. 
		call s:GotoWindow(windownum)
		exe 'let name = s:explorerName_'.numexp
		" if this is not occupying the entire height of the window, then call
		" its ReSize() function (if it exists).
		if exists('*'.name.'_ReSize') && !s:IsOnlyVertical()
			exe 'call '.name.'_ReSize()'
		end
		let i = i + 1
	endwhile
	call PrintError('done with refresh while loop')

	let &splitbelow = _split

	augroup WinManagerRefresh
		au!
		au BufEnter * call <SID>RefreshWinManager()
		au BufDelete * call <SID>RefreshWinManager("BufDelete")
	augroup END

	call s:GotoWindow(currentWindowNumber)
	" RepairAltRegister needs to be called here as well, because 
	" 1. when winmanager is re-started, we need to restore the @# register to
	"    what it was.
	" 2. if winmanager is started for the first time, then we need to ensure
	"    that @# is at least not one of the explorer windows.
	if buflisted(bufnr('%'))
		call s:RepairAltRegister()
	end
	let s:commandRunning = 0
	let &report=oldRep
	let &sc = save_sc
	if nothingShown
		echomsg "[ no valid explorers available. winmanager will start when next possible ]"
	end
endfunction

"---
" if this window occupies the entire height of the screen, return 1, else
" return 0. i.e return 1 if there is no window above or below this window.
"
function! <SID>IsOnlyVertical()
	let curwin = winnr()
	wincmd k
	if curwin != winnr()
		wincmd j
		return 0
	else
		wincmd j
		if winnr() != curwin
			wincmd k
			return 0
		end
	end
	return 1
endfunction

"---
" this function first takes focus to the last listed file being edited and
" then depending on the users action and modified, etc opens the file bufName
" either on it or splits a new window etc.
"
function! WinManagerFileEdit(bufName, split)
	" this function is usually _not_ triggered from an autocommand, so the
	" movement commands in this function will trigger RefreshWinManager().
	" make that do nothing with this flag.
	let s:commandRunning = 1
	let oldRep=&report
	let save_sc = &sc
	set report=10000 nosc
	
	" if the file is already visible somewhere just go there.
	" a:bufName is a fully qualified filename of the form
	"    e:/path/to/file
	" now bufnr('e:/path/to/file') != -1 even in the case where a file called
	" e:/path/to/file/other/name is opened. (this is bufnr()'s behavior).
	" therefore make an additional check so were protected against false
	" matches.
	if bufwinnr(bufnr(a:bufName)) != -1 &&
		\ a:bufName == expand('#'.bufnr(a:bufName).':p')

		call s:GotoWindow(bufwinnr(a:bufName))
		" however, we still have to repair the @# register
		call s:RepairAltRegister()

	" otherwise goto the last listed buffer being edited.
	else 

		" if we had already opened this file, then use the #n notation instead
		" of opening by file name. this preserves cursor position.
		if bufnr(a:bufName) != -1 &&
			\ a:bufName == expand('#'.bufnr(a:bufName).':p')
			let bufcall = '#'.bufnr(a:bufName)
		else
			let bufcall = a:bufName
		end

		let lastBufferNumber = s:MRUGet(1)
		" if the last accessed buffer is visible, then goto it.
		if bufwinnr(lastBufferNumber) != -1
			" the fact that we go to the last listed buffer and then open this
			" buffer automatically protects the @# register.
			call s:GotoWindow(bufwinnr(bufnr(lastBufferNumber)))
			" now split it or not depending on stuff.
			if (&modified && !&hidden) || a:split
				exe 'silent! split '.bufcall
			else
				exe 'silent! e '.bufcall
			end
		else
			" the last accessed buffer is not visible. this most probably
			" means that the explorer buffers are the only windows visible.
			" this means that the layout has to be redone by v-splitting a new
			" window for this file.
			" first open the alternate file just to retain @# if its still
			" listed. 
			if buflisted(lastBufferNumber)
				exe 'silent! vsplit #'.lastBufferNumber
				exe 'silent! e '.bufcall
			" the last accessed buffer has dissapeared. just edit this file.
			else
				exe 'silent! vsplit '.bufcall
			end
			" now push this to the very right
			wincmd L
			" calculate the width of this window and reset it.
			exe &columns-g:winManagerWidth.' wincmd |'
		end
	end

	let s:commandRunning = 0

	" call Refresh incase this fileopen made some displays invalid.
	call s:RefreshWinManager()
	let &report=oldRep
	let &sc = save_sc
endfunction


"---
" function to repair the @# register.
"
" quickly edit the alternate buffer previously being edited in the
" FileExplorer area so that the % and # registers are not screwed with.
" This function must be called while focus is on a listed buffer which needs
" to be made @%.
"
function! <SID>RepairAltRegister()
	" setting hidden while going back and forth is very wise because sometimes
	" this function is used from within an autocommand. in such cases,
	" switching back and forth between buffers makes the syntax highlighting
	" dissapear.
	let _hidden = &l:bufhidden
	setlocal bufhidden=hide
	let oldRep=&report
	let save_sc = &sc
	set report=10000 nosc

	let currentBufferNumber = bufnr('%')
	let currentBufferName = expand('%:p')
	let alternateBufferNumber = s:MRUGet(2)

	" if the required alternatebuffer exists, then first edit it to preserve @#
 	if alternateBufferNumber != bufnr("#") 
		\ && alternateBufferNumber != -1
		\ && buflisted(alternateBufferNumber)
 		exec 'silent! b! '.alternateBufferNumber
	elseif alternateBufferNumber == -1
	" if the alternate buffer doesnt exist, do some randomness so that the @#
	" register is at least not some explorer buffer number. ideally, at this
	" stage, something would have been done to ensure that @# = -1, however,
	" for now, edit a temporary file.
		exe "e ".tempname()
		setlocal nobuflisted
		setlocal nomodifiable
		setlocal bufhidden=delete
		setlocal buftype=nofile
		let tmpBufNum = bufnr('%')
		exe 'silent! b! '.currentBufferNumber
		exe 'silent! bwipeout '.tmpBufNum
		let &l:bufhidden = _hidden
		return
	end

 	" now edit the current file (to preserve @% :-) )
	" it seems that using ":b !" is _very_ important to preserve syntax
	" highlighting. if ":e #" or ":b " is used, then syntax highlighting is
	" lost and the ugly hack thing keeps getting called everytime. 
	" still dont know exactly why this is. it has something to do with
	" abandoned buffers being kept and also nested autocommands, but its not
	" very clear to me what it is.
	exec('silent! b! '.currentBufferNumber)

	" a totally ugly hack to restore syntax highlighting... i have NO idea why
	" this has to be here... somehow mixing opening files with autocommands
	" has always been very very problematic.
	" NOTE: the problem seems to have gone away now... see above comment.
	if has("syntax") && exists("g:syntax_on") && !has("syntax_items")
		call PrintError('needing to reset syntax!')
		do syntax
	else
		call PrintError('fugly hack not needed!')
	end
	" end fugly hack.

	let &l:bufhidden = _hidden
	let &report=oldRep
	let &sc = save_sc
endfunction

"---
" the main function. this is responsible for updating plugins dynamically.
" this function is triggered on the BufEnter and BufDelete events. every time
" it is called, it makes a pass through all visible plugins and if their
" display is not valid, it calls their Start() function.
"
" if this function is called with no arguments, it is assumed to be triggered
" from a BufEnter even or due to a forcible refresh. If it is called with one
" argument called "BufDelete", then it is assumed that it is triggered from
" the BufDelete event.
"
function! <SID>RefreshWinManager(...)
	" refreshes the window layout and the displayes of windows which trigger
	" on autocommands.
	
	" make a note of whether this refresh was triggered by the BufDelete event
	" or not.
	let _split = &splitbelow
	if a:0 > 0 && a:1 == "BufDelete"
		let BufDelete = 1
	else
		let BufDelete = 0
	end
	" do the push pop thing irrespective of whether we do the rest of the
	" stuff or not.
	if BufDelete
		call s:MRUPop()
	else
		call s:MRUPush()
	end
	" if this autocommand was triggered because of internal movements/commands
	" due to other winmanager commands, then quit.
	if exists("s:commandRunning") && s:commandRunning
		return
	end
	" check if only explorer windows are visible and if so quit if we dont
	" want persistent behavior.
	if !g:persistentBehaviour && s:OnlyExplorerWindowsOpen()
		qa
	end
	
	" this magic statement is curing the syntax losing problem. WHY?
	let s:commandRunning = 1
	let g:numRefs = g:numRefs + 1

	" remember this window number because we will return to it after
	" refreshing the buffer listing.
	let currentWindowNumber = winnr()
	let curBufListed = buflisted(bufnr('%'))
	let cfn = s:Path(expand("%:p"))

	" now cycle through all the visible explorers and and for each "invalid"ly
	" displayed explorer call its corresponding refresh and resize functions.
	let i = 1
	while i <= s:numExplorerGroups  && curBufListed
		" find if its visible and the explorer of this group which is
		" currently displayed.
		let windownum = s:IsExplorerGroupVisible(i)
		" if this explorer is visible, then call its _IsValid() function, etc.
		if windownum == -1
			let i = i + 1
			continue
		end
		let numexp = s:WhichMemberVisible(i)
		" visible, goto that window.
		call s:GotoWindow(windownum)
		exe 'let name = s:explorerName_'.numexp

		exe 'let explorerName = s:explorerName_'.numexp
		exe 'let isvalid = '.explorerName.'_IsValid()'
		" ... and if it isnt then update it.
		if !isvalid
			call <SID>GotoWindow(windownum)
			exe 'call '.explorerName.'_Start()'
			if exists('*'.explorerName.'_ReSize') && !s:IsOnlyVertical()
				exe 'call '.explorerName.'_ReSize()'
			end
		end
		let i = i + 1
	endwhile

	" this while loop handles the case where a group of explorers are was not
	" valid at some point and therefore didnt occupy a window, but became
	" valid after some point and therefore need to obtain a seperate window.
	let i = 1
	while i <= s:numExplorerGroups && curBufListed
		exe 'let retry = s:tryGroupAgain_'.i
		" only do this if we need to retry opening this buffer. we should not
		" keep opening a group which the user has closed using a ":quit"
		" command.
		if retry
			call PrintError('retrying group '.i)
			" find the 'nearest' group which is open.
			let nearestGroup = 'inf'
			let nearestWindow = 'inf'
			" TODO: possible bug: what if there are more than a million
			" plugins being used? :-)
			let nearestGroupDist = 1000000
			let j = 1
			while j <= s:numExplorerGroups
				
				let windownum = s:IsExplorerGroupVisible(j)
				if windownum != -1
					let dist = ( (j-i) < 0 ? (i-j) : (j-i) )
					if dist < nearestGroupDist
						let nearestGroupDist = dist
						let nearestGroup = j
						let nearestWindow = windownum
					end
				end
				let j = j + 1
			endwhile

			call PrintError('nearestWindow = '.nearestWindow)
			" if nearestWindow is 'inf', it means no other explorer plugins
			" are open. which means that this thing needs to go the very
			" right.
			if nearestWindow == 'inf'
				let ecmd = 'vsplit'
			else
				let ecmd = 'split'
				if nearestGroup > i
					setlocal nosplitbelow
				else
					setlocal splitbelow
				end
			end
			let somethingDisplayed = s:EditNextVisibleExplorer(i, 0, 1, ecmd)
			" if nothing was displayed this time, there is a possiblity it could
			" happen later during one of the refresh cycles. remember this for
			" then.
			if !somethingDisplayed
				exe 'let s:tryGroupAgain_'.i.' = 1'
				q
			else
				exe 'let s:tryGroupAgain_'.i.' = 0'
				let currentWindowNumber = currentWindowNumber + 1
				exe 'let name = s:explorerName_'.somethingDisplayed
				if exists('*'.name.'_ReSize') && !s:IsOnlyVertical()
					exe 'call '.name.'_ReSize()'
				end
				if nearestWindow == 'inf'
					wincmd H
					" set up the correct width
					" set width only if we are creating a new window...
					exe g:winManagerWidth.'wincmd |'
				end
				call PrintError('doing the funky open thing')
			end
		end
		let i = i + 1
	endwhile

	call s:ResizeAllExplorers()

	" refreshing done, now return back to where we were originally.
	call <SID>GotoWindow(currentWindowNumber)
	
	" however, we still have to "repair" the actual @% and @# registers, in
	" case we are returning to a listed buffer.  also should do this only for
	" a BufEnter event. For a BufDelete event, the do this only if the current
	" buffer is not the buffer being deleted.
	call PrintError('refresh: abuf = '.expand('<abuf>'))
	if buflisted(bufnr("%")) && !isdirectory(bufname("%")) && 
	\	( !BufDelete || ( bufnr('%') != expand('<abuf>') ) )
		call <SID>RepairAltRegister()
	end

	let s:commandRunning = 0
	let &splitbelow = _split
endfunction

function! <SID>ResizeAllExplorers()
	let i = 1
	while i <= s:numExplorers
		let explorerWinNum = s:IsExplorerVisible(i)
		if explorerWinNum != -1
			exe 'let explorerName = s:explorerName_'.i
			if exists('*'.explorerName.'_ReSize') && !s:IsOnlyVertical()
			" if a resize() function exists for this explorer and there
			" is some window above and/or below this window, then call its
			" resize function. this allows for dynamic resizing.
				call s:GotoWindow(explorerWinNum)
				exe 'call '.explorerName.'_ReSize()'
				call PrintError('calling resize for '.explorerName)
			end
		end
		let i = i + 1
	endwhile
endfunction

"---
" Make sure a path has proper form. 
" this function forces every path to take the following form
" dir1/dir2/file    OR
" dir1/dir2/dir/ 
" i.e, it replaces \ with / and stuff.
"
function! <SID>Path(p)
	let _p = a:p
	if a:p =~ '//$'
		return ""
	end
	if isdirectory(_p)
		let origdir= getcwd()
		exe "chdir" _p
		let _p = getcwd()
		exe "chdir" origdir
	end
	if has("dos16") || has("dos32") || has("win16") || has("win32") || has("os2")
		let _p = substitute(_p,'\\','/','g')
	endif
	if _p !~ '/$' && isdirectory(_p)
		let _p = _p.'/'
	endif
	return _p
endfunction

" goto the reqdWinNum^th window. returns 0 on failure otherwise 1.
function! <SID>GotoWindow(reqdWinNum)
	let startWinNum = winnr()
	if startWinNum == a:reqdWinNum
		return 1
	end
	if winbufnr(a:reqdWinNum) == -1
		return 0
	else
		exe a:reqdWinNum.' wincmd w'
		return 1
	end

endfunction

" returns the window number of the ith explorer if its visible, else -1
function! <SID>IsExplorerVisible(i)
	if exists('s:explorerBufNum_'.a:i)
		exe 'let explorerBufNum = s:explorerBufNum_'.a:i
	else
		let explorerBufNum = -1
	end
	return bufwinnr(explorerBufNum)
endfunction

" returns the window number of the first explorer of the ith explorer group if
" its visible, else -1
"
" if called with 2 arguments with the second being 'member', then returns the
" member number which is visible instead of its window number
"
function! <SID>IsExplorerGroupVisible(i, ...)
	" numList : the list of explorer numbers belonging to this group
	exe 'let numList = s:explorerGroupNums_'.a:i
	" ncl : next comma location
	" pcl : previous comma location
	let pcl = 0
	let ncl	= match(numList, ',', pcl + 1)
	while ncl != -1
		exe 'let num = '.strpart(numList, pcl + 1, ncl - pcl - 1)
		if s:IsExplorerVisible(num) != -1
			if a:0 == 1 && a:1 == 'mem'
				return num
			else
				return s:IsExplorerVisible(num)
			end
		end
		let pcl = ncl
		let ncl	= match(numList, ',', pcl + 1)
	endwhile
	return -1
endfunction

" returns the member number of the first explorer of the ith explorer group if
" its visible, else -1
function! <SID>WhichMemberVisible(i)
	return s:IsExplorerGroupVisible(a:i, 'mem')
endfunction

" a handy little function for debugging.
function! PrintError(eline)
	if !g:debugWinManager
		return
	end
	if !exists("g:myerror")
		let g:myerror = ""
	end
	let g:myerror = g:myerror . "\n" . a:eline
endfunction

"---
" find the memn^th member's explorer number of the groupn^th explorer group
" i.e, if s:explorerGroup_2 = ",3,4,5,"
" then FindExplorerInGroup(2,3) = 5
" 
" returs -1 if its not possible.
"
function! <SID>FindExplorerInGroup(groupn, memn)
	" numList : the list of explorer numbers belonging to this group
	exe 'let numList = s:explorerGroupNums_'.a:groupn

	let num = s:Strntok2(numList, ',', a:memn)
	if num == ''
		return -1
	end
	exe 'return '.num
endfunction

"---
" goto the next explorer in the group which this one belongs to.
" if called with 2 arguments, goto the previous explorer.
"
function! <SID>GotoNextExplorerInGroup(name, ...)
	let s:commandRunning = 1
	" go forward or back?
	if a:0 > 1
		let dir = -1
	else
		let dir = 1
	end

	" first extract the ID variable from the name
	exe 'let grpn = s:'.a:name.'_groupID'
	exe 'let memn = s:'.a:name.'_memberID'
	exe 'let numn = s:'.a:name.'_numberID'

	" find the number of members of this group.
	exe 'let nummems = s:numMembers_'.grpn
	if nummems == 1
		return 0
	end

	if exists('*'.a:name.'_WrapUp')
		exe 'call '.a:name.'_WrapUp()'
	end

	let curbufnum = bufnr('%')
	let somethingDisplayed = s:EditNextVisibleExplorer(grpn, memn, dir, 'e')
	if !somethingDisplayed && curbufnum != bufnr('%')
	   	" now start the next explorer using its title
	   	exe 'let title = s:explorerTitle_'.numn
	   	exe 'silent! e '.title
		setlocal nobuflisted
		setlocal bufhidden=delete
		setlocal buftype=nofile
		setlocal noswapfile

		" call the Start() function for the next explorer ...
		exe 'call '.a:name.'_Start()'
		exe 'nnoremap <buffer> <C-n> :WinManagerGotoNextInGroup "'.a:name.'"<cr>'
		exe 'nnoremap <buffer> <C-p> :WinManagerGotoPrevInGroup "'.a:name.'"<cr>'
		setlocal nomodifiable
		call WinManagerForceReSize(a:name)
	end

	let s:commandRunning = 0
endfunction

" edit the first possible explorer after memn belonging to groun. use editcmd
" to form the new window.
function! <SID>EditNextVisibleExplorer(grpn, memn, dir, editcmd)
	
	call PrintError('EditNext: grpn = '.a:grpn.', memn = '.a:memn.', dir = '.a:dir.' editcmd = '.a:editcmd)
	" then try to find the number of the next member.
	let startmn = (a:memn ? a:memn : 1)
	let nextmn = a:memn + a:dir
	let editcmd = a:editcmd

	let somethingDisplayed = 0

	let once = 0
	" enter this loop at least once
	while nextmn != startmn || !once
	" cycle through the next explorers in this group finding out the next
	" explorer which says its able to display anything at all.
		let once = 1
	
		let nextEN = s:FindExplorerInGroup(a:grpn, nextmn)
		" if the next member doesnt exist wrap around.
		if nextEN == -1 
			if a:dir == 1
				let nextEN = s:FindExplorerInGroup(a:grpn, 1)
				let nextmn = 1
				continue
			else
				let nextEN = s:FindExplorerInGroup(a:grpn, nummems)
				let nextmn = nummems
				continue
			end
		end

		" if we have come back to the same explorer with every other group
		" member not able to display anything, then return.
		call PrintError('nextmn = '.nextmn.' a:memn = '.a:memn)

		exe 'let name = s:explorerName_'.nextEN
		" if the _IsPossible() function doesn't exist, assume its always
		" possible to display stuff.
		let isposs = 1
		if exists('*'.name.'_IsPossible')
			exe 'let isposs = '.name.'_IsPossible()'
		end
		if isposs
			" now start the next explorer using its title
			exe 'let title = s:explorerTitle_'.nextEN
			exe 'let name = s:explorerName_'.nextEN
			exe 'silent! '.editcmd.' '.title
			" use vsplitting etc only the first time things are opened.
			if editcmd != 'e'
				let editcmd = 'e'
			end
			" these are a few setting which most well-made explorers
			" already set, but just to be on the safe side.
			setlocal nobuflisted
			setlocal bufhidden=delete
			setlocal buftype=nofile
			setlocal noswapfile

			" call the Start() function for the next explorer ...
			exe 'call '.name.'_Start()'
			setlocal nomodifiable
			" and remember its buffer number for later.
			exe 'let s:explorerBufNum_'.nextEN.' = bufnr("%")'
			" also remember that this was the last explorer of this group which was
			" displayed.
			exe 'let s:lastMemberDisplayed_'.a:grpn.' = nextmn'

			" if this explorer has actually not put anything in the buffer
			" then quit and forget.
			if line('$') > 0 && getline('$') != ''
				let somethingDisplayed = nextEN
				break
			end
		end
		" goto the next explorer of the group.
		let nextmn = nextmn + a:dir
	endwhile

	if somethingDisplayed
		" and then add this mapping to switch to the next/previous
		" explorer in this group
		exe 'nnoremap <buffer> <C-n> :WinManagerGotoNextInGroup "'.name.'"<cr>'
		exe 'nnoremap <buffer> <C-p> :WinManagerGotoPrevInGroup "'.name.'"<cr>'
	end
	return somethingDisplayed
endfunction


" goes to either the first explorer window or the last explorer window
" visible.
function! <SID>GotoExplorerWindow(which)
	let s:commandRunning = 1
	" first go to either the top left or the bottom right window.
	if a:which == '1'
		" goto to the top left and move in the bottom/right direction.
		wincmd t
		let winmovecmd = 'wincmd w'
	else
		wincmd b
		let winmovecmd = 'wincmd W'
	end
	" remember the window we started from.
	let startWin = winnr()
	let firstTime = 1
	" then begin cycling through all the windows either going in the
	" bottom/right direction or the top/left direction.
	while 1
		" if we are on an explorer window quit.
		if s:IsExplorerBuffer(bufnr('%'))
			let s:commandRunning = 0
			return
		end
		" if we have cycled through one complete time without hitting pay
		" dirt, quit.
		if winnr() == startWin && !firstTime
			" TODO: this will screw the @% and @# register.
			break
		end
		let firstTime = 0
		exe winmovecmd
	endwhile
	let s:commandRunning = 0
endfunction

" returns the explorer number if an explorer plugin exists with the specified
" buffer number
function! <SID>IsExplorerBuffer(num)
	let i = 1
	while i <= s:numExplorers
		if exists('s:explorerBufNum_'.i)
			exe 'let bufnum = s:explorerBufNum_'.i
			if bufnum == a:num
				return i
			end
		end
		let i = i + 1
	endwhile
	return 0
endfunction

" toggle showing the explorer plugins.
function! <SID>ToggleWindowsManager()
	if IsWinManagerVisible()
		call s:CloseWindowsManager()
	else
		call s:StartWindowsManager()
	end
endfunction

" exported function. returns the buffer number of the last file being edited
" in the file editing area.
function! WinManagerGetLastEditedFile(...)
	if a:0 == 0
		return s:MRUGet(1)
	else
		let ret = s:MRUGet(a:1)
		if ret == ''
			return matchstr(s:MRUList, ',\zs[0-9]\+\ze,$')
		else
			return ret
		end
endfunction


" exported function. returns 1 if any of the explorer windows are open,
" otherwise returns 0.
function! IsWinManagerVisible()
	let i = 1
	while i <= s:numExplorers
		if s:IsExplorerVisible(i) != -1
			return 1
		end
		let i = i + 1
	endwhile
	return 0
endfunction


" close all the visible explorer windows.
function! <SID>CloseWindowsManager()
	let s:commandRunning = 1

	let i = 1
	while i <= bufnr('$')
		let explNum = s:IsExplorerBuffer(i)
		if explNum > 0 && bufwinnr(i) != -1
			exe 'bd '.i
		end
		let i = i + 1
	endwhile

	let s:commandRunning = 0
endfunction

" provides a way to examine script local variables from outside the script.
" very handy for debugging.
function! <SID>ShowVariableValue(...)
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

" the following functions are hooks provided by winmanager to external plugins
" as a way to get winmanager to stop getting triggered on AUs. This is useful
" when an explorer plugin triggers a BufEnter or BufDelete *internally*. For
" example, bufexplorer.vim's "delete buffer" function triggers a BufDelete
" function.
"
function! WinManagerSuspendAUs()
	let s:commandRunning = 1
endfunction
function! WinManagerResumeAUs()
	let s:commandRunning = 0
endfunction

" Another hook provided by winmanager. Normally winmanager will call the
" plugins resize function every time the BufEnter or BufDelete event is
" triggered. However, sometimes a plugin might change the number of lines
" *internally*. In this case, the plugin could make a call to this function
" which will make a safety check and then call its resize function.
"
function! WinManagerForceReSize(explName)
	if !exists('s:'.a:explName.'_numberID') || !exists('*'.a:explName.'_ReSize')
		call PrintError('resize quitting because resize function not found or explorer not registered')
		return
	end
	exe 'let explNum = s:'.a:explName.'_numberID'
	let s:commandRunning = 1
	let windowNum = s:IsExplorerVisible(explNum)
	if windowNum == -1
		call PrintError('resize quitting because window not visible')
		return
	end
	call s:GotoWindow(windowNum)
	if s:IsOnlyVertical()
		call PrintError('resize quitting because its illegal')
		return
	end
	exe 'call '.a:explName.'_ReSize()'
	let s:commandRunning = 0
endfunction

" returns 1 if the only visible windows are explorer windows.
function! <SID>OnlyExplorerWindowsOpen()
	let i = 1
	" loop over all open windows
	while 1
		" if we have checked all open windows and not returned yet, then it
		" means only explorers are visible.
		if winbufnr(i) == -1
			return 1
		end
		" if this is a non-explorer window then return 0
		if !s:IsExplorerBuffer(winbufnr(i))
			return 0
		end
		let i = i + 1
	endwhile
endfunction

" MRUPush
function! <SID>MRUPush()
	if buflisted(bufnr("%")) && !isdirectory(bufname("%"))
		let _bufNbr = bufnr('%')
		let _list = substitute(s:MRUList, ','._bufNbr.',', ',', '')
		let s:MRUList = ','._bufNbr._list
		unlet _bufNbr _list
	end
endfunction

" MRUPop
function! <SID>MRUPop()
	let _bufNbr = expand('<abuf>')
	let s:MRUList = substitute(s:MRUList, ''._bufNbr.',', '', '')
	unlet _bufNbr
endfunction

" MRUGet
function! <SID>MRUGet(slot)
	let ret = s:Strntok2(s:MRUList, ',', a:slot)
	if ret == ''
		return -1
	end
	exe 'return '.ret
endfunction

" Strntok:
" extract the n^th token from s seperated by tok. 
" example: Strntok('1,23,3', ',', 2) = 23
fun! <SID>Strntok(s, tok, n)
	return matchstr( a:s.a:tok[0], '\v(\zs([^'.a:tok.']*)\ze['.a:tok.']){'.a:n.'}')
endfun

" Strntok2
" same as Strntok except that s is delimited by the tok character at the
" beginning and end.
" example: Strntok2(',1,23,3,', ',', 2) = 23
fun! <SID>Strntok2(s, tok, n)
	return matchstr( a:s, '\v((['.a:tok.']\zs[^'.a:tok.']*)\ze){'.a:n.'}')
endfun

" InitializeMRUList 
"
" initialize the MRU list. initially this will be just the buffers in the
" order of their buffer numbers with the @% and @# leading. The MRU list
" consists of a string of the following form: ",1,2,3,4,"
" NOTE: there are commas at the beginning and the end. this is to make
" identifying the position of buffers in the list easier even if they occur in
" the beginning or end and in situations where one buffer number is part of
" another. i.e the string "9" is part of the string "19"
" 
function! <SID>InitializeMRUList()
	let nBufs = bufnr('$')
	let _i = 1

	" put the % and the # numbers at the beginning if they are listed.
	let s:MRUList = ''
	if buflisted(bufnr("%"))
		let s:MRUList = ','.bufnr("%")
	end
	if buflisted(bufnr("#"))
		let s:MRUList = s:MRUList.','.bufnr("#")
	end
	let s:MRUList = s:MRUList.','
	
	" then proceed with the rest of the buffers
	while _i <= nBufs
		" dont keep unlisted buffers in the MRU list.
		if buflisted(_i) && bufnr("%") != _i && bufnr("#") != _i
			let s:MRUList = s:MRUList._i.','
		end
		let _i = _i + 1
	endwhile
	" Doing this makes bufexplorer.vim display the first two listed buffers as
	" @% and @# which they actually are when winmanager starts up after doing
	" something like:
	"    vim *.vim
	"    :WMtoggle
	let g:MRUList = s:MRUList
endfunction

if !g:defaultExplorer
	let loaded_explorer = 1
	"---
	" Set up the autocommand to allow directories to be edited
	"
	augroup fileExplorer
		au!
		au VimEnter * call s:EditDir("VimEnter")
		au BufEnter * call s:EditDir("BufEnter")
	augroup end
end

" handles editing a directory via winmanager.
function! <SID>EditDir(event)
	" return immediately if this isn't a directory.
	let name = expand("%")
	if name == ""
		let name = expand("%:p")
	endif
	if !isdirectory(name)
		return
	endif
	
	" if it is, then call the modified explorer.vim's Explore command.
	if a:event != "VimEnter"
 		if exists(":Explore")
 			ExploreInCurrentWindow
 		end
	end
	" if we have entered vim while editing a directory, then remove the
	" directory buffer, and start the window layout.
	" Note that we only start up winmanager in a VimEnter event because we
	" want commands such as ":e /some/dir/" within vim to have the same effect
	" as with the standard explorer.vim plugin which ships with vim.
	"
	" NOTE: if the user has chosen a layout where the FileExplorer is not at
	" the top-left, this will be unintuitive.
	if a:event == "VimEnter"
		bwipeout
		
		call s:StartWindowsManager()
		call s:MRUPush()
		call s:GotoExplorerWindow('1')
 	end
endfunction

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save
" vim:ts=4:noet:sw=4

" Set auto open Winmanager
if exists('g:AutoOpenWinManager') && g:AutoOpenWinManager
    if filewritable(expand('%')) && exists('g:AutoOpenFiletype')
        for _filetype in g:AutoOpenFiletype
            if expand('%:e') == _filetype
                autocmd VimEnter * nested call s:StartWindowsManager()
                break
            endif
        endfor
    endif
endif
