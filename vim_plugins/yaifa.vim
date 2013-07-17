" YAIFA: Yet Another Indent Finder, Almost...
" Version: 1.3
" Modified: 2010-08-17
" Author: Israel Chauca F. <israelchauca@gmail.com>
"
" This plug-in will try to detect the kind of indentation in your file and set
" Vim's options to keep it that way. It recognizes three types of indentation:
"
" 1.- Space: Only spaces are used to indent.
"
" 2.- Tab: Only tabs are used.
"
" 3.- Mixed: A combination of tabs and space is used. e.g.: a tab stands for 8
"     spaces, but each indentation level is 4 spaces.
"
" Use :YAIFAMagic to manually set the indenting settings for the current file.
"
" Depending on the system set-up and the file size scanning too many lines can
" be painfully slow, so YAIFA processes 2048 lines by default, that value can
" be changed with the following line in your .vimrc:
"
"    let yaifa_max_lines = 4096
"
" This script is a port to VimL from Philippe Fremy's Python script Indent
" Finder, hence the "Almost" part of the name.

if exists('g:loaded_yaifa')
        finish
endif

let g:loaded_yaifa = 1

" Depending on your system and file size, scanning too many lines can be
" painfully slow.
if exists('g:yaifa_max_lines')
        let s:max_lines = g:yaifa_max_lines
else
        let s:max_lines = 1024*2
endif

redir => redir | silent verbose set sw? | redir END
let s:swset = len(split(redir,"\n")) > 1

if &expandtab
        let s:default_indent = 'space'
        let s:default_tab_width = s:swset ? &sw : 2
else
        let s:default_indent = 'tab'
        let s:default_tab_width = s:swset ? &sw : 4
endif


let s:verbose_quiet = 0
let s:verbose_info  = 1
let s:verbose_debug = 2
let s:verbose_deep  = 3
if exists('g:yaifa_verbosity')
        let s:verbosity = g:yaifa_verbosity
else
        let s:default_verbosity = s:verbose_quiet
        let s:verbosity = s:default_verbosity
endif

let s:default_result = [s:default_indent, s:default_tab_width]
let s:nb_processed_lines = 0

let s:NoIndent = "NoIndent"
let s:SpaceOnly = "SpaceOnly"
let s:TabOnly = "TabOnly"
let s:Mixed = "Mixed"
let s:BeginSpace = "BeginSpace"
let s:indent_re = '\m^\(\s\+\)\(\S.\+\)$'
let s:mixed_re = '\m^\(\t\)\+\( \+\)$'

function! s:log(level, s)
        if a:level <= s:verbosity
                echomsg s:nb_processed_lines . ':' . a:s
        endif
endfunction

function! s:info(s)
        call s:log(s:verbose_info, 'info:' . a:s)
endfunction

function! s:dbg(s)
        call s:log(s:verbose_debug, 'dbg:' . a:s)
endfunction

function! s:deepdbg(s)
        call s:log(s:verbose_deep, 'deep:' . a:s)
endfunction

function! s:clear()
        let s:lines = {}
        for i in range(2,9)
                let s:lines[i] = 0
                let s:lines[-1 * i ] = 0
        endfor
        let s:lines.tab = 0

        let s:nb_processed_lines = 0
        let s:nb_indent_hint = 0
        let s:skip_next_line = 0
        let s:previous_line_info = []
endfunction

function! s:parse_file()
        "let nb_lines = line('$') < s:max_lines ? line('$') : s:max_lines
        let nb_lines = line('$')
        let i = 1
        "while i <= nb_lines
        while i <= nb_lines && s:nb_processed_lines < s:max_lines
                call s:analyse_line(getline(i))
                let i += 1
        endw
endf

function! s:analyse_line(line)
        let line = substitute(a:line, '\m\n', '', '')
        call s:deepdbg('analyse_line: ' . substitute(substitute(line, '\m\t', '\\t', 'g'), '\m ', '·','g'))
        let s:nb_processed_lines += 1
        let skip_current_line = s:skip_next_line
        let s:skip_next_line = 0
        if line =~ '\m\\$'
                call s:deepdbg('analyse_line: Ignoring next line!')
                let s:skip_next_line = 1
        endif

        if skip_current_line
                call s:deepdbg('analyse_line: Ignoring next line!')
                return
        endif
        let ret = s:analyse_line_indentation(line)
        if ret
                let s:nb_indent_hint += 1
                call s:deepdbg('analyse_line: Result of line analysis: ' . ret)
        endif
        return ret
endfunction

function! s:analyse_line_type(line)
        let mixed_mode = 0
        let tab_part = ""
        let space_part = ""

        if a:line !~ '\m^$' && a:line !~ '\m^\s'
                cal s:deepdbg('analyse_line_type: line is not empty and not indented: ')
                return [s:NoIndent, '']
        endif

        if a:line !~ s:indent_re
                cal s:deepdbg('analyse_line_type: line is not indented')
                return []
        else
                let indent_part = substitute(a:line, s:indent_re, '\1', '')
                let text_part = substitute(a:line, s:indent_re, '\2', '')
        endif
        call s:deepdbg('analyse_line_type: indent_part="' . substitute(substitute(substitute(indent_part, '\m\n', '\\n', 'g'), '\m\t', '\\t', 'g'), ' ', '·', 'g') . '"')

        if text_part =~ '\m^\*'
                " continuation of a C/C++ comment, unlikely to be indented correctly
                return []
        endif

        if a:line =~ '\m^(/\*\|#)'
                " python, C/C++ comment, might not be indented correctly
                return []
        endif

        if indent_part =~ '\m\t' && indent_part =~ '\m '
                "Mixed mode
                "let mo = indent_part =~ s:mixed_re
                if indent_part !~ s:mixed_re
                        " Line is not composed of "\t\t\t   "
                        return []
                endif
                let mixed_mode = 1
                let tab_part = substitute(indent_part, s:mixed_re, '\1','')
                let space_part = substitute(indent_part, s:mixed_re, '\2','')
        endif

        if mixed_mode
                if len(space_part) >= 8
                        "this is not mixed mode, this is garbage !
                        return []
                endif
                return [s:Mixed, tab_part, space_part]
        endif"

        if indent_part =~ '\m\t'
                return [s:TabOnly, indent_part]
        endif

        if indent_part =~ '\m '
                if len(indent_part) < 8
                        " this could be mixed mode too
                        return [s:BeginSpace, indent_part]
                else
                        " this is really a line indented with spaces
                        return [s:SpaceOnly, indent_part]
                endif
        endif
        echoerr 'We should never get here!'
endfunction

function! s:analyse_line_indentation(line)
        let previous_line_info = s:previous_line_info
        let current_line_info = s:analyse_line_type(a:line)
        let s:previous_line_info = current_line_info

        if len(current_line_info) == 0 || len(previous_line_info) == 0
                "call s:deepdbg('analyse_line_indentation: Not enough info to analyse line : ' . string(previous_line_info) . ':' . string(current_line_info))
                return 0
        endif

        let t = [previous_line_info[0], current_line_info[0]]
        call s:deepdbg('analyse_line_indentation: Indent analysis: ' . string(t))

        if t == [s:TabOnly, s:TabOnly]
                                \ || t == [s:NoIndent, s:TabOnly]
                if len(current_line_info[1]) - len(previous_line_info[1]) == 1
                        let s:lines['tab'] += 1
                        return 'tab'
                endif
        elseif t == [s:SpaceOnly, s:SpaceOnly]
                                \ || t == [s:BeginSpace, s:SpaceOnly]
                                \ || t == [s:NoIndent, s:SpaceOnly]
                let nb_space = len(current_line_info[1]) - len(previous_line_info[1])
                if 1 < nb_space && nb_space <= 8
                        "execute 'let key = "space' . nb_space . '"'
                        let key = nb_space
                        let s:lines[key] += 1
                        return key
                endif
        elseif t == [s:BeginSpace, s:BeginSpace]
                                \ || t == [s:NoIndent, s:BeginSpace]
                let nb_space = len(current_line_info[1]) - len(previous_line_info[1])
                if 1 < nb_space && nb_space <= 8
                        "execute 'let key1 = "space' . nb_space . '"'
                        "execute 'let key2 = "mixed' . nb_space . '"'
                        let key1 = nb_space
                        let key2 = -1 * nb_space
                        let s:lines[key1] += 1
                        let s:lines[key2] += 1
                        return key1
                endif
        elseif t == [s:BeginSpace, s:TabOnly]
                " We assume that mixed indentation used 8 chars tabs
                if len(current_line_info[1]) == 1
                        let nb_space = len(current_line_info[1]) - len(previous_line_info[1])
                        if 1 < nb_space && nb_space <= 8
                                "execute 'let key = "mixed' . nb_space . '"'
                                let key = -1 * nb_space
                                let s:lines[key] += 1
                                return key
                        endif
                endif
        elseif t == [s:TabOnly, s:Mixed]
                let tab_part = current_line_info[1]
                let space_part = current_line_info[2]
                if len(previous_line_info[1]) == len(tab_part)
                        let nb_space = len(space_part)
                        if 1 < nb_space && nb_space <= 8
                                "execute 'let key = "mixed' . nb_space . '"'
                                let key = -1 * nb_space
                                let s:lines[key] += 1
                                return key
                        endif
                endif
        elseif t == [s:Mixed, s:TabOnly]
                let tab_part = previous_line_info[1]
                let space_part = previous_line_info[2]
                if len(tab_part) + 1 == len(current_line_info[1])
                        let nb_space = 8 - len(space_part)
                        if 1 < nb_space && nb_space <= 8
                                "execute 'let key = "mixed' . nb_space . '"'
                                let key = -1 * nb_space
                                let s:lines[key] += 1
                                return key
                        endif
                endif
        endif
        return 0
endfunction

function! s:results()
        call s:dbg( "Nb of scanned lines : " . s:nb_processed_lines)
        call s:dbg( "Nb of indent hint : " . s:nb_indent_hint)
        "call s:dbg( "Collected data:")
        for key in keys(s:lines)
                if s:lines[key] > 0
                        call s:dbg( '    Key ' . key . ' => ' . s:lines[key])
                endif
        endfor
        let spaces = []
        let mixed = []
        for i in range(2,9)
                "execute 'let spaces = add(spaces, s:lines.space' . i . ')'
                let spaces = add(spaces, s:lines[i])
                "execute 'let mixed = add(mixed, s:lines.mixed' . i . ')'
                let mixed = add(mixed, s:lines[-1 * i])
        endfor
        let max_line_space = max(spaces)
        let max_line_mixed = max(mixed)
        let max_line_tab = s:lines.tab

        call s:dbg( 'max_line_space: ' . max_line_space )
        call s:dbg( 'max_line_mixed: ' . max_line_mixed )
        call s:dbg( 'max_line_tab: ' . max_line_tab )


        """ Result analysis
        "
        " 1. Space indented file
        "    - lines indented with less than 8 space will fill mixed and space array
        "    - lines indented with 8 space or more will fill only the space array
        "    - almost no lines indented with tab
        "
        " => more lines with space than lines with mixed
        " => more a lot more lines with space than tab
        "
        " 2. Tab indented file
        "    - most lines will be tab only
        "    - very few lines as mixed
        "    - very few lines as space only
        "
        " => a lot more lines with tab than lines with mixed
        " => a lot more lines with tab than lines with space
        "
        " 3. Mixed tab/space indented file
        "    - some lines are tab-only (lines with exactly 8 step indentation)
        "    - some lines are space only (less than 8 space)
        "    - all other lines are mixed
        "
        " If mixed is tab + 2 space indentation:
        "     - a lot more lines with mixed than with tab
        " If mixed is tab + 4 space indentation
        "     - as many lines with mixed than with tab
        "
        " If no lines exceed 8 space, there will be only lines with space
        " and tab but no lines with mixed. Impossible to detect mixed indentation
        " in this case, the file looks like it's actually indented as space only
        " and will be detected so.
        "
        " => same or more lines with mixed than lines with tab only
        " => same or more lines with mixed than lines with space only
        "

        let result = []
        " Detect space indented file
        if max_line_space >= max_line_mixed && max_line_space > max_line_tab
                let nb = 0
                let indent_value = 0
                for i in range(8,2,-1)
                        "execute 'let m = s:lines.space' . i . ' > floor(nb * 1.1)'
                        "if s:lines[i] > floor(nb * 1.1)
                        if s:lines[i] * 10 > nb * 11
                                let indent_value = i
                                "execute 'let nb = s:lines.space' . i
                                let nb = s:lines[i]
                        endif
                endfor

                if indent_value == 0
                        let result = s:default_result
                else
                        let result = ['space', indent_value]
                endif

        " Detect tab files
        elseif max_line_tab > max_line_mixed && max_line_tab > max_line_space
                let result = ['tab', s:default_tab_width]

        " Detect mixed files
        elseif max_line_mixed >= max_line_tab && max_line_mixed > max_line_space
                let nb = 0
                let indent_value = 0
                for i in range(-8,-2)
                        "execute 'let m = s:lines.mixed' . i . ' > floor(nb * 1.1)'
                        "let m = s:lines[i] > floor(nb * 1.1)
                        "if s:lines[i] > floor(nb * 1.1)
                        if s:lines[i] * 10 > nb * 11
                                let indent_value = -1 * i
                                "execute 'let nb = s:lines.mixed' . i
                                let nb = s:lines[i]
                        endif
                endfor

                if indent_value == 0
                        let result = s:default_result
                else
                        let result = ['mixed', [8, indent_value]]
                endif

        " Not enough information to make a decision
        else
                let result = s:default_result
        endif
        call s:info('Result: ' . string(result))
        return result
endfunction

function! YAIFA(...)

        " The magic starts here
        call s:clear()
        call s:parse_file()

        let result = s:results()

        if result[0] == 'space'
                call s:info('space')
                "spaces:
                " => set sts to the number of spaces
                " => set tabstop to 8
                " => expand tabs to spaces
                " => set shiftwidth to the number of spaces
                let cmd = 'set sts=' . result[1] . ' | set tabstop=8 | set expandtab | set shiftwidth=' . result[1]
        elseif result[0] == 'tab'
                call s:info('tab')
                "tab:
                " => set sts to 0
                " => set tabstop to preferred value
                " => set expandtab to false
                " => set shiftwidth to tabstop
                let cmd = 'set sts=0 | set tabstop=' . s:default_tab_width . ' | set noexpandtab | set shiftwidth=' . s:default_tab_width
        elseif result[0] == 'mixed'
                call s:info('mixed')
                "tab:
                " => set sts to 0
                " => set tabstop to tab_indent
                " => set expandtab to false
                " => set shiftwidth to space_indent
                let s:ts = result[1][0]
                let s:sw = result[1][1]
                "echom "s:sw: " . s:sw
                "if s:sw == "" && (s:ts - (2*(s:ts/2))) == 0 " l mod 2
                if s:sw == "" && s:ts > 2
                        let s:sw = s:ts/2
                elseif s:sw == ""
                        let s:sw = s:ts
                endif

                let cmd = 'set sts=' . s:sw . ' | set tabstop=' . s:ts . ' | set noexpandtab | set shiftwidth=' . s:sw
        endif
        execute cmd
        let b:yaifa_set = 1
        if a:0 > 0
                if a:1 == 2
                        if result[0] == "space"
                                return "space" . result[1]
                        elseif result[0] == "tab"
                                return "tab"
                        else
                                return "mixed" . s:sw
                        endif
                endif
        else
                echom cmd
        endif
endfunction

function! YAIFAGetVar(var)
        exec "return s:".a:var
endfunction

augroup YAIFA
        au! YAIFA
        au BufRead * call YAIFA(1)
augroup End

command -nargs=0 -bar YAIFAMagic call YAIFA()
