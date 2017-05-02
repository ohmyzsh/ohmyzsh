" File: taglist.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 4.5
" Last Modified: September 21, 2007
" Copyright: Copyright (C) 2002-2007 Yegappan Lakshmanan
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            taglist.vim is provided *as is* and comes with no warranty of any
"            kind, either expressed or implied. In no event will the copyright
"            holder be liable for any damamges resulting from the use of this
"            software.
"
" The "Tag List" plugin is a source code browser plugin for Vim and provides
" an overview of the structure of the programming language files and allows
" you to efficiently browse through source code files for different
" programming languages.  You can visit the taglist plugin home page for more
" information:
"
"       http://vim-taglist.sourceforge.net
"
" You can subscribe to the taglist mailing list to post your questions
" or suggestions for improvement or to report bugs. Visit the following
" page for subscribing to the mailing list:
"
"       http://groups.yahoo.com/group/taglist/
"
" For more information about using this plugin, after installing the
" taglist plugin, use the ":help taglist" command.
"
" Installation
" ------------
" 1. Download the taglist.zip file and unzip the files to the $HOME/.vim
"    or the $HOME/vimfiles or the $VIM/vimfiles directory. This should
"    unzip the following two files (the directory structure should be
"    preserved):
"
"       plugin/taglist.vim - main taglist plugin file
"       doc/taglist.txt    - documentation (help) file
"
"    Refer to the 'add-plugin', 'add-global-plugin' and 'runtimepath'
"    Vim help pages for more details about installing Vim plugins.
" 2. Change to the $HOME/.vim/doc or $HOME/vimfiles/doc or
"    $VIM/vimfiles/doc directory, start Vim and run the ":helptags ."
"    command to process the taglist help file.
" 3. If the exuberant ctags utility is not present in your PATH, then set the
"    Tlist_Ctags_Cmd variable to point to the location of the exuberant ctags
"    utility (not to the directory) in the .vimrc file.
" 4. If you are running a terminal/console version of Vim and the
"    terminal doesn't support changing the window width then set the
"    'Tlist_Inc_Winwidth' variable to 0 in the .vimrc file.
" 5. Restart Vim.
" 6. You can now use the ":TlistToggle" command to open/close the taglist
"    window. You can use the ":help taglist" command to get more
"    information about using the taglist plugin.
"
" ****************** Do not modify after this line ************************

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

if !exists('loaded_taglist')
    " First time loading the taglist plugin
    "
    " To speed up the loading of Vim, the taglist plugin uses autoload
    " mechanism to load the taglist functions.
    " Only define the configuration variables, user commands and some
    " auto-commands and finish sourcing the file

    " The taglist plugin requires the built-in Vim system() function. If this
    " function is not available, then don't load the plugin.
    if !exists('*system')
        echomsg 'Taglist: Vim system() built-in function is not available. ' .
                    \ 'Plugin is not loaded.'
        let loaded_taglist = 'no'
        let &cpo = s:cpo_save
        finish
    endif

    " Location of the exuberant ctags tool
    if !exists('Tlist_Ctags_Cmd')
        if executable('exuberant-ctags')
            " On Debian Linux, exuberant ctags is installed
            " as exuberant-ctags
            let Tlist_Ctags_Cmd = 'exuberant-ctags'
        elseif executable('exctags')
            " On Free-BSD, exuberant ctags is installed as exctags
            let Tlist_Ctags_Cmd = 'exctags'
        elseif executable('ctags')
            let Tlist_Ctags_Cmd = 'ctags'
        elseif executable('ctags.exe')
            let Tlist_Ctags_Cmd = 'ctags.exe'
        elseif executable('tags')
            let Tlist_Ctags_Cmd = 'tags'
        else
            echomsg 'Taglist: Exuberant ctags (http://ctags.sf.net) ' .
                        \ 'not found in PATH. Plugin is not loaded.'
            " Skip loading the plugin
            let loaded_taglist = 'no'
            let &cpo = s:cpo_save
            finish
        endif
    endif


    " Automatically open the taglist window on Vim startup
    if !exists('Tlist_Auto_Open')
        let Tlist_Auto_Open = 0
    endif

    " When the taglist window is toggle opened, move the cursor to the
    " taglist window
    if !exists('Tlist_GainFocus_On_ToggleOpen')
        let Tlist_GainFocus_On_ToggleOpen = 0
    endif

    " Process files even when the taglist window is not open
    if !exists('Tlist_Process_File_Always')
        let Tlist_Process_File_Always = 0
    endif

    if !exists('Tlist_Show_Menu')
        let Tlist_Show_Menu = 0
    endif

    " Tag listing sort type - 'name' or 'order'
    if !exists('Tlist_Sort_Type')
        let Tlist_Sort_Type = 'order'
    endif

    " Tag listing window split (horizontal/vertical) control
    if !exists('Tlist_Use_Horiz_Window')
        let Tlist_Use_Horiz_Window = 0
    endif

    " Open the vertically split taglist window on the left or on the right
    " side.  This setting is relevant only if Tlist_Use_Horiz_Window is set to
    " zero (i.e.  only for vertically split windows)
    if !exists('Tlist_Use_Right_Window')
        let Tlist_Use_Right_Window = 0
    endif

    " Increase Vim window width to display vertically split taglist window.
    " For MS-Windows version of Vim running in a MS-DOS window, this must be
    " set to 0 otherwise the system may hang due to a Vim limitation.
    if !exists('Tlist_Inc_Winwidth')
        if (has('win16') || has('win95')) && !has('gui_running')
            let Tlist_Inc_Winwidth = 0
        else
            let Tlist_Inc_Winwidth = 1
        endif
    endif

    " Vertically split taglist window width setting
    if !exists('Tlist_WinWidth')
        let Tlist_WinWidth = 30
    endif

    " Horizontally split taglist window height setting
    if !exists('Tlist_WinHeight')
        let Tlist_WinHeight = 10
    endif

    " Display tag prototypes or tag names in the taglist window
    if !exists('Tlist_Display_Prototype')
        let Tlist_Display_Prototype = 0
    endif

    " Display tag scopes in the taglist window
    if !exists('Tlist_Display_Tag_Scope')
        let Tlist_Display_Tag_Scope = 1
    endif

    " Use single left mouse click to jump to a tag. By default this is disabled.
    " Only double click using the mouse will be processed.
    if !exists('Tlist_Use_SingleClick')
        let Tlist_Use_SingleClick = 0
    endif

    " Control whether additional help is displayed as part of the taglist or
    " not.  Also, controls whether empty lines are used to separate the tag
    " tree.
    if !exists('Tlist_Compact_Format')
        let Tlist_Compact_Format = 0
    endif

    " Exit Vim if only the taglist window is currently open. By default, this is
    " set to zero.
    if !exists('Tlist_Exit_OnlyWindow')
        let Tlist_Exit_OnlyWindow = 0
    endif

    " Automatically close the folds for the non-active files in the taglist
    " window
    if !exists('Tlist_File_Fold_Auto_Close')
        let Tlist_File_Fold_Auto_Close = 0
    endif

    " Close the taglist window when a tag is selected
    if !exists('Tlist_Close_On_Select')
        let Tlist_Close_On_Select = 0
    endif

    " Automatically update the taglist window to display tags for newly
    " edited files
    if !exists('Tlist_Auto_Update')
        let Tlist_Auto_Update = 1
    endif

    " Automatically highlight the current tag
    if !exists('Tlist_Auto_Highlight_Tag')
        let Tlist_Auto_Highlight_Tag = 1
    endif
    
    " Automatically highlight the current tag on entering a buffer
    if !exists('Tlist_Highlight_Tag_On_BufEnter')
        let Tlist_Highlight_Tag_On_BufEnter = 1
    endif

    " Enable fold column to display the folding for the tag tree
    if !exists('Tlist_Enable_Fold_Column')
        let Tlist_Enable_Fold_Column = 1
    endif

    " Display the tags for only one file in the taglist window
    if !exists('Tlist_Show_One_File')
        let Tlist_Show_One_File = 0
    endif

    if !exists('Tlist_Max_Submenu_Items')
        let Tlist_Max_Submenu_Items = 20
    endif

    if !exists('Tlist_Max_Tag_Length')
        let Tlist_Max_Tag_Length = 10
    endif

    " Do not change the name of the taglist title variable. The winmanager
    " plugin relies on this name to determine the title for the taglist
    " plugin.
    let TagList_title = "__Tag_List__"

    " Taglist debug messages
    let s:tlist_msg = ''

    " Define the taglist autocommand to automatically open the taglist window
    " on Vim startup
    if g:Tlist_Auto_Open
        autocmd VimEnter * nested call s:Tlist_Window_Check_Auto_Open()
    endif

    " Refresh the taglist
    if g:Tlist_Process_File_Always
        "autocmd BufEnter * call s:Tlist_Refresh()
        autocmd CursorHold * call s:Tlist_Refresh()
    endif

    if g:Tlist_Show_Menu
        autocmd GUIEnter * call s:Tlist_Menu_Init()
    endif

    " When the taglist buffer is created when loading a Vim session file,
    " the taglist buffer needs to be initialized. The BufFilePost event
    " is used to handle this case.
    autocmd BufFilePost __Tag_List__ call s:Tlist_Vim_Session_Load()

    " Define the user commands to manage the taglist window
    command! -nargs=0 -bar TlistToggle call s:Tlist_Window_Toggle()
    command! -nargs=0 -bar TlistOpen call s:Tlist_Window_Open()
    " For backwards compatiblity define the Tlist command
    command! -nargs=0 -bar Tlist TlistToggle
    command! -nargs=+ -complete=file TlistAddFiles
                \  call s:Tlist_Add_Files(<f-args>)
    command! -nargs=+ -complete=dir TlistAddFilesRecursive
                \ call s:Tlist_Add_Files_Recursive(<f-args>)
    command! -nargs=0 -bar TlistClose call s:Tlist_Window_Close()
    command! -nargs=0 -bar TlistUpdate call s:Tlist_Update_Current_File()
    command! -nargs=0 -bar TlistHighlightTag call s:Tlist_Window_Highlight_Tag(
                        \ fnamemodify(bufname('%'), ':p'), line('.'), 2, 1)
    " For backwards compatiblity define the TlistSync command
    command! -nargs=0 -bar TlistSync TlistHighlightTag
    command! -nargs=* -complete=buffer TlistShowPrototype
                \ echo Tlist_Get_Tag_Prototype_By_Line(<f-args>)
    command! -nargs=* -complete=buffer TlistShowTag
                \ echo Tlist_Get_Tagname_By_Line(<f-args>)
    command! -nargs=* -complete=file TlistSessionLoad
                \ call s:Tlist_Session_Load(<q-args>)
    command! -nargs=* -complete=file TlistSessionSave
                \ call s:Tlist_Session_Save(<q-args>)
    command! -bar TlistLock let Tlist_Auto_Update=0
    command! -bar TlistUnlock let Tlist_Auto_Update=1

    " Commands for enabling/disabling debug and to display debug messages
    command! -nargs=? -complete=file -bar TlistDebug
                \ call s:Tlist_Debug_Enable(<q-args>)
    command! -nargs=0 -bar TlistUndebug  call s:Tlist_Debug_Disable()
    command! -nargs=0 -bar TlistMessages call s:Tlist_Debug_Show()

    " Define autocommands to autoload the taglist plugin when needed.

    " Trick to get the current script ID
    map <SID>xx <SID>xx
    let s:tlist_sid = substitute(maparg('<SID>xx'), '<SNR>\(\d\+_\)xx$',
                                \ '\1', '')
    unmap <SID>xx

    exe 'autocmd FuncUndefined *' . s:tlist_sid . 'Tlist_* source ' .
                \ escape(expand('<sfile>'), ' ')
    exe 'autocmd FuncUndefined *' . s:tlist_sid . 'Tlist_Window_* source ' .
                \ escape(expand('<sfile>'), ' ')
    exe 'autocmd FuncUndefined *' . s:tlist_sid . 'Tlist_Menu_* source ' .
                \ escape(expand('<sfile>'), ' ')
    exe 'autocmd FuncUndefined Tlist_* source ' .
                \ escape(expand('<sfile>'), ' ')
    exe 'autocmd FuncUndefined TagList_* source ' .
                \ escape(expand('<sfile>'), ' ')

    let loaded_taglist = 'fast_load_done'

    if g:Tlist_Show_Menu && has('gui_running')
        call s:Tlist_Menu_Init()
    endif

    " restore 'cpo'
    let &cpo = s:cpo_save
    finish
endif

if !exists('s:tlist_sid')
    " Two or more versions of taglist plugin are installed. Don't
    " load this version of the plugin.
    finish
endif

unlet! s:tlist_sid

if loaded_taglist != 'fast_load_done'
    " restore 'cpo'
    let &cpo = s:cpo_save
    finish
endif

" Taglist plugin functionality is available
let loaded_taglist = 'available'

"------------------- end of user configurable options --------------------

" Default language specific settings for supported file types and tag types
"
" Variable name format:
"
"       s:tlist_def_{vim_ftype}_settings
" 
" vim_ftype - Filetype detected by Vim
"
" Value format:
"
"       <ctags_ftype>;<flag>:<name>;<flag>:<name>;...
"
" ctags_ftype - File type supported by exuberant ctags
" flag        - Flag supported by exuberant ctags to generate a tag type
" name        - Name of the tag type used in the taglist window to display the
"               tags of this type
"

" assembly language
let s:tlist_def_asm_settings = 'asm;d:define;l:label;m:macro;t:type'

" aspperl language
let s:tlist_def_aspperl_settings = 'asp;f:function;s:sub;v:variable'

" aspvbs language
let s:tlist_def_aspvbs_settings = 'asp;f:function;s:sub;v:variable'

" awk language
let s:tlist_def_awk_settings = 'awk;f:function'

" beta language
let s:tlist_def_beta_settings = 'beta;f:fragment;s:slot;v:pattern'

" c language
let s:tlist_def_c_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;' .
                           \ 'v:variable;f:function'

" c++ language
let s:tlist_def_cpp_settings = 'c++;n:namespace;v:variable;d:macro;t:typedef;' .
                             \ 'c:class;g:enum;s:struct;u:union;f:function'

" c# language
let s:tlist_def_cs_settings = 'c#;d:macro;t:typedef;n:namespace;c:class;' .
                             \ 'E:event;g:enum;s:struct;i:interface;' .
                             \ 'p:properties;m:method'

" cobol language
let s:tlist_def_cobol_settings = 'cobol;d:data;f:file;g:group;p:paragraph;' .
                               \ 'P:program;s:section'

" eiffel language
let s:tlist_def_eiffel_settings = 'eiffel;c:class;f:feature'

" erlang language
let s:tlist_def_erlang_settings = 'erlang;d:macro;r:record;m:module;f:function'

" expect (same as tcl) language
let s:tlist_def_expect_settings = 'tcl;c:class;f:method;p:procedure'

" fortran language
let s:tlist_def_fortran_settings = 'fortran;p:program;b:block data;' .
                    \ 'c:common;e:entry;i:interface;k:type;l:label;m:module;' .
                    \ 'n:namelist;t:derived;v:variable;f:function;s:subroutine'

" HTML language
let s:tlist_def_html_settings = 'html;a:anchor;f:javascript function'

" java language
let s:tlist_def_java_settings = 'java;p:package;c:class;i:interface;' .
                              \ 'f:field;m:method'

" javascript language
let s:tlist_def_javascript_settings = 'javascript;f:function'

" lisp language
let s:tlist_def_lisp_settings = 'lisp;f:function'

" lua language
let s:tlist_def_lua_settings = 'lua;f:function'

" makefiles
let s:tlist_def_make_settings = 'make;m:macro'

" pascal language
let s:tlist_def_pascal_settings = 'pascal;f:function;p:procedure'

" perl language
let s:tlist_def_perl_settings = 'perl;c:constant;l:label;p:package;s:subroutine'

" php language
let s:tlist_def_php_settings = 'php;c:class;d:constant;v:variable;f:function'

" python language
let s:tlist_def_python_settings = 'python;c:class;m:member;f:function'

" rexx language
let s:tlist_def_rexx_settings = 'rexx;s:subroutine'

" ruby language
let s:tlist_def_ruby_settings = 'ruby;c:class;f:method;F:function;' .
                              \ 'm:singleton method'

" scheme language
let s:tlist_def_scheme_settings = 'scheme;s:set;f:function'

" shell language
let s:tlist_def_sh_settings = 'sh;f:function'

" C shell language
let s:tlist_def_csh_settings = 'sh;f:function'

" Z shell language
let s:tlist_def_zsh_settings = 'sh;f:function'

" slang language
let s:tlist_def_slang_settings = 'slang;n:namespace;f:function'

" sml language
let s:tlist_def_sml_settings = 'sml;e:exception;c:functor;s:signature;' .
                             \ 'r:structure;t:type;v:value;f:function'

" sql language
let s:tlist_def_sql_settings = 'sql;c:cursor;F:field;P:package;r:record;' .
            \ 's:subtype;t:table;T:trigger;v:variable;f:function;p:procedure'

" tcl language
let s:tlist_def_tcl_settings = 'tcl;c:class;f:method;m:method;p:procedure'

" vera language
let s:tlist_def_vera_settings = 'vera;c:class;d:macro;e:enumerator;' .
                                \ 'f:function;g:enum;m:member;p:program;' .
                                \ 'P:prototype;t:task;T:typedef;v:variable;' .
                                \ 'x:externvar'

"verilog language
let s:tlist_def_verilog_settings = 'verilog;m:module;c:constant;P:parameter;' .
            \ 'e:event;r:register;t:task;w:write;p:port;v:variable;f:function'

" vim language
let s:tlist_def_vim_settings = 'vim;a:autocmds;v:variable;f:function'

" yacc language
let s:tlist_def_yacc_settings = 'yacc;l:label'

"------------------- end of language specific options --------------------

" Vim window size is changed by the taglist plugin or not
let s:tlist_winsize_chgd = -1
" Taglist window is maximized or not
let s:tlist_win_maximized = 0
" Name of files in the taglist
let s:tlist_file_names=''
" Number of files in the taglist
let s:tlist_file_count = 0
" Number of filetypes supported by taglist
let s:tlist_ftype_count = 0
" Is taglist part of other plugins like winmanager or cream?
let s:tlist_app_name = "none"
" Are we displaying brief help text
let s:tlist_brief_help = 1
" List of files removed on user request
let s:tlist_removed_flist = ""
" Index of current file displayed in the taglist window
let s:tlist_cur_file_idx = -1
" Taglist menu is empty or not
let s:tlist_menu_empty = 1

" An autocommand is used to refresh the taglist window when entering any
" buffer. We don't want to refresh the taglist window if we are entering the
" file window from one of the taglist functions. The 'Tlist_Skip_Refresh'
" variable is used to skip the refresh of the taglist window and is set
" and cleared appropriately.
let s:Tlist_Skip_Refresh = 0

" Tlist_Window_Display_Help()
function! s:Tlist_Window_Display_Help()
    if s:tlist_app_name == "winmanager"
        " To handle a bug in the winmanager plugin, add a space at the
        " last line
        call setline('$', ' ')
    endif

    if s:tlist_brief_help
        " Add the brief help
        call append(0, '" Press <F1> to display help text')
    else
        " Add the extensive help
        call append(0, '" <enter> : Jump to tag definition')
        call append(1, '" o : Jump to tag definition in new window')
        call append(2, '" p : Preview the tag definition')
        call append(3, '" <space> : Display tag prototype')
        call append(4, '" u : Update tag list')
        call append(5, '" s : Select sort field')
        call append(6, '" d : Remove file from taglist')
        call append(7, '" x : Zoom-out/Zoom-in taglist window')
        call append(8, '" + : Open a fold')
        call append(9, '" - : Close a fold')
        call append(10, '" * : Open all folds')
        call append(11, '" = : Close all folds')
        call append(12, '" [[ : Move to the start of previous file')
        call append(13, '" ]] : Move to the start of next file')
        call append(14, '" q : Close the taglist window')
        call append(15, '" <F1> : Remove help text')
    endif
endfunction

" Tlist_Window_Toggle_Help_Text()
" Toggle taglist plugin help text between the full version and the brief
" version
function! s:Tlist_Window_Toggle_Help_Text()
    if g:Tlist_Compact_Format
        " In compact display mode, do not display help
        return
    endif

    " Include the empty line displayed after the help text
    let brief_help_size = 1
    let full_help_size = 16

    setlocal modifiable

    " Set report option to a huge value to prevent informational messages
    " while deleting the lines
    let old_report = &report
    set report=99999

    " Remove the currently highlighted tag. Otherwise, the help text
    " might be highlighted by mistake
    match none

    " Toggle between brief and full help text
    if s:tlist_brief_help
        let s:tlist_brief_help = 0

        " Remove the previous help
        exe '1,' . brief_help_size . ' delete _'

        " Adjust the start/end line numbers for the files
        call s:Tlist_Window_Update_Line_Offsets(0, 1, full_help_size - brief_help_size)
    else
        let s:tlist_brief_help = 1

        " Remove the previous help
        exe '1,' . full_help_size . ' delete _'

        " Adjust the start/end line numbers for the files
        call s:Tlist_Window_Update_Line_Offsets(0, 0, full_help_size - brief_help_size)
    endif

    call s:Tlist_Window_Display_Help()

    " Restore the report option
    let &report = old_report

    setlocal nomodifiable
endfunction

" Taglist debug support
let s:tlist_debug = 0

" File for storing the debug messages
let s:tlist_debug_file = ''

" Tlist_Debug_Enable
" Enable logging of taglist debug messages.
function! s:Tlist_Debug_Enable(...)
    let s:tlist_debug = 1

    " Check whether a valid file name is supplied.
    if a:1 != ''
        let s:tlist_debug_file = fnamemodify(a:1, ':p')

        " Empty the log file
        exe 'redir! > ' . s:tlist_debug_file
        redir END

        " Check whether the log file is present/created
        if !filewritable(s:tlist_debug_file)
            call s:Tlist_Warning_Msg('Taglist: Unable to create log file '
                        \ . s:tlist_debug_file)
            let s:tlist_debug_file = ''
        endif
    endif
endfunction

" Tlist_Debug_Disable
" Disable logging of taglist debug messages.
function! s:Tlist_Debug_Disable(...)
    let s:tlist_debug = 0
    let s:tlist_debug_file = ''
endfunction

" Tlist_Debug_Show
" Display the taglist debug messages in a new window
function! s:Tlist_Debug_Show()
    if s:tlist_msg == ''
        call s:Tlist_Warning_Msg('Taglist: No debug messages')
        return
    endif

    " Open a new window to display the taglist debug messages
    new taglist_debug.txt
    " Delete all the lines (if the buffer already exists)
    silent! %delete _
    " Add the messages
    silent! put =s:tlist_msg
    " Move the cursor to the first line
    normal! gg
endfunction

" Tlist_Log_Msg
" Log the supplied debug message along with the time
function! s:Tlist_Log_Msg(msg)
    if s:tlist_debug
        if s:tlist_debug_file != ''
            exe 'redir >> ' . s:tlist_debug_file
            silent echon strftime('%H:%M:%S') . ': ' . a:msg . "\n"
            redir END
        else
            " Log the message into a variable
            " Retain only the last 3000 characters
            let len = strlen(s:tlist_msg)
            if len > 3000
                let s:tlist_msg = strpart(s:tlist_msg, len - 3000)
            endif
            let s:tlist_msg = s:tlist_msg . strftime('%H:%M:%S') . ': ' . 
                        \ a:msg . "\n"
        endif
    endif
endfunction

" Tlist_Warning_Msg()
" Display a message using WarningMsg highlight group
function! s:Tlist_Warning_Msg(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction

" Last returned file index for file name lookup.
" Used to speed up file lookup
let s:tlist_file_name_idx_cache = -1

" Tlist_Get_File_Index()
" Return the index of the specified filename
function! s:Tlist_Get_File_Index(fname)
    if s:tlist_file_count == 0 || a:fname == ''
        return -1
    endif

    " If the new filename is same as the last accessed filename, then
    " return that index
    if s:tlist_file_name_idx_cache != -1 &&
                \ s:tlist_file_name_idx_cache < s:tlist_file_count
        if s:tlist_{s:tlist_file_name_idx_cache}_filename == a:fname
            " Same as the last accessed file
            return s:tlist_file_name_idx_cache
        endif
    endif

    " First, check whether the filename is present
    let s_fname = a:fname . "\n"
    let i = stridx(s:tlist_file_names, s_fname)
    if i == -1
        let s:tlist_file_name_idx_cache = -1
        return -1
    endif

    " Second, compute the file name index
    let nl_txt = substitute(strpart(s:tlist_file_names, 0, i), "[^\n]", '', 'g')
    let s:tlist_file_name_idx_cache = strlen(nl_txt)
    return s:tlist_file_name_idx_cache
endfunction

" Last returned file index for line number lookup.
" Used to speed up file lookup
let s:tlist_file_lnum_idx_cache = -1

" Tlist_Window_Get_File_Index_By_Linenum()
" Return the index of the filename present in the specified line number
" Line number refers to the line number in the taglist window
function! s:Tlist_Window_Get_File_Index_By_Linenum(lnum)
    call s:Tlist_Log_Msg('Tlist_Window_Get_File_Index_By_Linenum (' . a:lnum . ')')

    " First try to see whether the new line number is within the range
    " of the last returned file
    if s:tlist_file_lnum_idx_cache != -1 &&
                \ s:tlist_file_lnum_idx_cache < s:tlist_file_count
        if a:lnum >= s:tlist_{s:tlist_file_lnum_idx_cache}_start &&
                    \ a:lnum <= s:tlist_{s:tlist_file_lnum_idx_cache}_end
            return s:tlist_file_lnum_idx_cache
        endif
    endif

    let fidx = -1

    if g:Tlist_Show_One_File
        " Displaying only one file in the taglist window. Check whether
        " the line is within the tags displayed for that file
        if s:tlist_cur_file_idx != -1
            if a:lnum >= s:tlist_{s:tlist_cur_file_idx}_start
                        \ && a:lnum <= s:tlist_{s:tlist_cur_file_idx}_end
                let fidx = s:tlist_cur_file_idx
            endif

        endif
    else
        " Do a binary search in the taglist
        let left = 0
        let right = s:tlist_file_count - 1

        while left < right
            let mid = (left + right) / 2

            if a:lnum >= s:tlist_{mid}_start && a:lnum <= s:tlist_{mid}_end
                let s:tlist_file_lnum_idx_cache = mid
                return mid
            endif

            if a:lnum < s:tlist_{mid}_start
                let right = mid - 1
            else
                let left = mid + 1
            endif
        endwhile

        if left >= 0 && left < s:tlist_file_count
                    \ && a:lnum >= s:tlist_{left}_start
                    \ && a:lnum <= s:tlist_{left}_end
            let fidx = left
        endif
    endif

    let s:tlist_file_lnum_idx_cache = fidx

    return fidx
endfunction

" Tlist_Exe_Cmd_No_Acmds
" Execute the specified Ex command after disabling autocommands
function! s:Tlist_Exe_Cmd_No_Acmds(cmd)
    let old_eventignore = &eventignore
    set eventignore=all
    exe a:cmd
    let &eventignore = old_eventignore
endfunction

" Tlist_Skip_File()
" Check whether tag listing is supported for the specified file
function! s:Tlist_Skip_File(filename, ftype)
    " Skip buffers with no names and buffers with filetype not set
    if a:filename == '' || a:ftype == ''
        return 1
    endif

    " Skip files which are not supported by exuberant ctags
    " First check whether default settings for this filetype are available.
    " If it is not available, then check whether user specified settings are
    " available. If both are not available, then don't list the tags for this
    " filetype
    let var = 's:tlist_def_' . a:ftype . '_settings'
    if !exists(var)
        let var = 'g:tlist_' . a:ftype . '_settings'
        if !exists(var)
            return 1
        endif
    endif

    " Skip files which are not readable or files which are not yet stored
    " to the disk
    if !filereadable(a:filename)
        return 1
    endif

    return 0
endfunction

" Tlist_User_Removed_File
" Returns 1 if a file is removed by a user from the taglist
function! s:Tlist_User_Removed_File(filename)
    return stridx(s:tlist_removed_flist, a:filename . "\n") != -1
endfunction

" Tlist_Update_Remove_List
" Update the list of user removed files from the taglist
" add == 1, add the file to the removed list
" add == 0, delete the file from the removed list
function! s:Tlist_Update_Remove_List(filename, add)
    if a:add
        let s:tlist_removed_flist = s:tlist_removed_flist . a:filename . "\n"
    else
        let idx = stridx(s:tlist_removed_flist, a:filename . "\n")
        let text_before = strpart(s:tlist_removed_flist, 0, idx)
        let rem_text = strpart(s:tlist_removed_flist, idx)
        let next_idx = stridx(rem_text, "\n")
        let text_after = strpart(rem_text, next_idx + 1)

        let s:tlist_removed_flist = text_before . text_after
    endif
endfunction

" Tlist_FileType_Init
" Initialize the ctags arguments and tag variable for the specified
" file type
function! s:Tlist_FileType_Init(ftype)
    call s:Tlist_Log_Msg('Tlist_FileType_Init (' . a:ftype . ')')
    " If the user didn't specify any settings, then use the default
    " ctags args. Otherwise, use the settings specified by the user
    let var = 'g:tlist_' . a:ftype . '_settings'
    if exists(var)
        " User specified ctags arguments
        let settings = {var} . ';'
    else
        " Default ctags arguments
        let var = 's:tlist_def_' . a:ftype . '_settings'
        if !exists(var)
            " No default settings for this file type. This filetype is
            " not supported
            return 0
        endif
        let settings = s:tlist_def_{a:ftype}_settings . ';'
    endif

    let msg = 'Taglist: Invalid ctags option setting - ' . settings

    " Format of the option that specifies the filetype and ctags arugments:
    "
    "       <language_name>;flag1:name1;flag2:name2;flag3:name3
    "

    " Extract the file type to pass to ctags. This may be different from the
    " file type detected by Vim
    let pos = stridx(settings, ';')
    if pos == -1
        call s:Tlist_Warning_Msg(msg)
        return 0
    endif
    let ctags_ftype = strpart(settings, 0, pos)
    if ctags_ftype == ''
        call s:Tlist_Warning_Msg(msg)
        return 0
    endif
    " Make sure a valid filetype is supplied. If the user didn't specify a
    " valid filetype, then the ctags option settings may be treated as the
    " filetype
    if ctags_ftype =~ ':'
        call s:Tlist_Warning_Msg(msg)
        return 0
    endif

    " Remove the file type from settings
    let settings = strpart(settings, pos + 1)
    if settings == ''
        call s:Tlist_Warning_Msg(msg)
        return 0
    endif

    " Process all the specified ctags flags. The format is
    " flag1:name1;flag2:name2;flag3:name3
    let ctags_flags = ''
    let cnt = 0
    while settings != ''
        " Extract the flag
        let pos = stridx(settings, ':')
        if pos == -1
            call s:Tlist_Warning_Msg(msg)
            return 0
        endif
        let flag = strpart(settings, 0, pos)
        if flag == ''
            call s:Tlist_Warning_Msg(msg)
            return 0
        endif
        " Remove the flag from settings
        let settings = strpart(settings, pos + 1)

        " Extract the tag type name
        let pos = stridx(settings, ';')
        if pos == -1
            call s:Tlist_Warning_Msg(msg)
            return 0
        endif
        let name = strpart(settings, 0, pos)
        if name == ''
            call s:Tlist_Warning_Msg(msg)
            return 0
        endif
        let settings = strpart(settings, pos + 1)

        let cnt = cnt + 1

        let s:tlist_{a:ftype}_{cnt}_name = flag
        let s:tlist_{a:ftype}_{cnt}_fullname = name
        let ctags_flags = ctags_flags . flag
    endwhile

    let s:tlist_{a:ftype}_ctags_args = '--language-force=' . ctags_ftype .
                            \ ' --' . ctags_ftype . '-types=' . ctags_flags
    let s:tlist_{a:ftype}_count = cnt
    let s:tlist_{a:ftype}_ctags_flags = ctags_flags

    " Save the filetype name
    let s:tlist_ftype_{s:tlist_ftype_count}_name = a:ftype
    let s:tlist_ftype_count = s:tlist_ftype_count + 1

    return 1
endfunction

" Tlist_Detect_Filetype
" Determine the filetype for the specified file using the filetypedetect
" autocmd.
function! s:Tlist_Detect_Filetype(fname)
    " Ignore the filetype autocommands
    let old_eventignore = &eventignore
    set eventignore=FileType

    " Save the 'filetype', as this will be changed temporarily
    let old_filetype = &filetype

    " Run the filetypedetect group of autocommands to determine
    " the filetype
    exe 'doautocmd filetypedetect BufRead ' . a:fname

    " Save the detected filetype
    let ftype = &filetype

    " Restore the previous state
    let &filetype = old_filetype
    let &eventignore = old_eventignore

    return ftype
endfunction

" Tlist_Get_Buffer_Filetype
" Get the filetype for the specified buffer
function! s:Tlist_Get_Buffer_Filetype(bnum)
    let buf_ft = getbufvar(a:bnum, '&filetype')

    if bufloaded(a:bnum)
        " For loaded buffers, the 'filetype' is already determined
        return buf_ft
    endif

    " For unloaded buffers, if the 'filetype' option is set, return it
    if buf_ft != ''
        return buf_ft
    endif

    " Skip non-existent buffers
    if !bufexists(a:bnum)
        return ''
    endif

    " For buffers whose filetype is not yet determined, try to determine
    " the filetype
    let bname = bufname(a:bnum)

    return s:Tlist_Detect_Filetype(bname)
endfunction

" Tlist_Discard_TagInfo
" Discard the stored tag information for a file
function! s:Tlist_Discard_TagInfo(fidx)
    call s:Tlist_Log_Msg('Tlist_Discard_TagInfo (' .
                \ s:tlist_{a:fidx}_filename . ')')
    let ftype = s:tlist_{a:fidx}_filetype

    " Discard information about the tags defined in the file
    let i = 1
    while i <= s:tlist_{a:fidx}_tag_count
        let fidx_i = 's:tlist_' . a:fidx . '_' . i
        unlet! {fidx_i}_tag
        unlet! {fidx_i}_tag_name
        unlet! {fidx_i}_tag_type
        unlet! {fidx_i}_ttype_idx
        unlet! {fidx_i}_tag_proto
        unlet! {fidx_i}_tag_searchpat
        unlet! {fidx_i}_tag_linenum
        let i = i + 1
    endwhile

    let s:tlist_{a:fidx}_tag_count = 0

    " Discard information about tag type groups
    let i = 1
    while i <= s:tlist_{ftype}_count
        let ttype = s:tlist_{ftype}_{i}_name
        if s:tlist_{a:fidx}_{ttype} != ''
            let fidx_ttype = 's:tlist_' . a:fidx . '_' . ttype
            let {fidx_ttype} = ''
            let {fidx_ttype}_offset = 0
            let cnt = {fidx_ttype}_count
            let {fidx_ttype}_count = 0
            let j = 1
            while j <= cnt
                unlet! {fidx_ttype}_{j}
                let j = j + 1
            endwhile
        endif
        let i = i + 1
    endwhile

    " Discard the stored menu command also
    let s:tlist_{a:fidx}_menu_cmd = ''
endfunction

" Tlist_Window_Update_Line_Offsets
" Update the line offsets for tags for files starting from start_idx
" and displayed in the taglist window by the specified offset
function! s:Tlist_Window_Update_Line_Offsets(start_idx, increment, offset)
    let i = a:start_idx

    while i < s:tlist_file_count
        if s:tlist_{i}_visible
            " Update the start/end line number only if the file is visible
            if a:increment
                let s:tlist_{i}_start = s:tlist_{i}_start + a:offset
                let s:tlist_{i}_end = s:tlist_{i}_end + a:offset
            else
                let s:tlist_{i}_start = s:tlist_{i}_start - a:offset
                let s:tlist_{i}_end = s:tlist_{i}_end - a:offset
            endif
        endif
        let i = i + 1
    endwhile
endfunction

" Tlist_Discard_FileInfo
" Discard the stored information for a file
function! s:Tlist_Discard_FileInfo(fidx)
    call s:Tlist_Log_Msg('Tlist_Discard_FileInfo (' .
                \ s:tlist_{a:fidx}_filename . ')')
    call s:Tlist_Discard_TagInfo(a:fidx)

    let ftype = s:tlist_{a:fidx}_filetype

    let i = 1
    while i <= s:tlist_{ftype}_count
        let ttype = s:tlist_{ftype}_{i}_name
        unlet! s:tlist_{a:fidx}_{ttype}
        unlet! s:tlist_{a:fidx}_{ttype}_offset
        unlet! s:tlist_{a:fidx}_{ttype}_count
        let i = i + 1
    endwhile

    unlet! s:tlist_{a:fidx}_filename
    unlet! s:tlist_{a:fidx}_sort_type
    unlet! s:tlist_{a:fidx}_filetype
    unlet! s:tlist_{a:fidx}_mtime
    unlet! s:tlist_{a:fidx}_start
    unlet! s:tlist_{a:fidx}_end
    unlet! s:tlist_{a:fidx}_valid
    unlet! s:tlist_{a:fidx}_visible
    unlet! s:tlist_{a:fidx}_tag_count
    unlet! s:tlist_{a:fidx}_menu_cmd
endfunction

" Tlist_Window_Remove_File_From_Display
" Remove the specified file from display
function! s:Tlist_Window_Remove_File_From_Display(fidx)
    call s:Tlist_Log_Msg('Tlist_Window_Remove_File_From_Display (' .
                \ s:tlist_{a:fidx}_filename . ')')
    " If the file is not visible then no need to remove it
    if !s:tlist_{a:fidx}_visible
        return
    endif

    " Remove the tags displayed for the specified file from the window
    let start = s:tlist_{a:fidx}_start
    " Include the empty line after the last line also
    if g:Tlist_Compact_Format
        let end = s:tlist_{a:fidx}_end
    else
        let end = s:tlist_{a:fidx}_end + 1
    endif

    setlocal modifiable
    exe 'silent! ' . start . ',' . end . 'delete _'
    setlocal nomodifiable

    " Correct the start and end line offsets for all the files following
    " this file, as the tags for this file are removed
    call s:Tlist_Window_Update_Line_Offsets(a:fidx + 1, 0, end - start + 1)
endfunction

" Tlist_Remove_File
" Remove the file under the cursor or the specified file index
" user_request - User requested to remove the file from taglist
function! s:Tlist_Remove_File(file_idx, user_request)
    let fidx = a:file_idx

    if fidx == -1
        let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(line('.'))
        if fidx == -1
            return
        endif
    endif
    call s:Tlist_Log_Msg('Tlist_Remove_File (' .
                \ s:tlist_{fidx}_filename . ', ' . a:user_request . ')')

    let save_winnr = winnr()
    let winnum = bufwinnr(g:TagList_title)
    if winnum != -1
        " Taglist window is open, remove the file from display

        if save_winnr != winnum
            let old_eventignore = &eventignore
            set eventignore=all
            exe winnum . 'wincmd w'
        endif

        call s:Tlist_Window_Remove_File_From_Display(fidx)

        if save_winnr != winnum
            exe save_winnr . 'wincmd w'
            let &eventignore = old_eventignore
        endif
    endif

    let fname = s:tlist_{fidx}_filename

    if a:user_request
        " As the user requested to remove the file from taglist,
        " add it to the removed list
        call s:Tlist_Update_Remove_List(fname, 1)
    endif

    " Remove the file name from the taglist list of filenames
    let idx = stridx(s:tlist_file_names, fname . "\n")
    let text_before = strpart(s:tlist_file_names, 0, idx)
    let rem_text = strpart(s:tlist_file_names, idx)
    let next_idx = stridx(rem_text, "\n")
    let text_after = strpart(rem_text, next_idx + 1)
    let s:tlist_file_names = text_before . text_after

    call s:Tlist_Discard_FileInfo(fidx)

    " Shift all the file variables by one index
    let i = fidx + 1

    while i < s:tlist_file_count
        let j = i - 1

        let s:tlist_{j}_filename = s:tlist_{i}_filename
        let s:tlist_{j}_sort_type = s:tlist_{i}_sort_type
        let s:tlist_{j}_filetype = s:tlist_{i}_filetype
        let s:tlist_{j}_mtime = s:tlist_{i}_mtime
        let s:tlist_{j}_start = s:tlist_{i}_start
        let s:tlist_{j}_end = s:tlist_{i}_end
        let s:tlist_{j}_valid = s:tlist_{i}_valid
        let s:tlist_{j}_visible = s:tlist_{i}_visible
        let s:tlist_{j}_tag_count = s:tlist_{i}_tag_count
        let s:tlist_{j}_menu_cmd = s:tlist_{i}_menu_cmd

        let k = 1
        while k <= s:tlist_{j}_tag_count
            let s:tlist_{j}_{k}_tag = s:tlist_{i}_{k}_tag
            let s:tlist_{j}_{k}_tag_name = s:tlist_{i}_{k}_tag_name
            let s:tlist_{j}_{k}_tag_type = s:Tlist_Get_Tag_Type_By_Tag(i, k)
            let s:tlist_{j}_{k}_ttype_idx = s:tlist_{i}_{k}_ttype_idx
            let s:tlist_{j}_{k}_tag_proto = s:Tlist_Get_Tag_Prototype(i, k)
            let s:tlist_{j}_{k}_tag_searchpat = s:Tlist_Get_Tag_SearchPat(i, k)
            let s:tlist_{j}_{k}_tag_linenum = s:Tlist_Get_Tag_Linenum(i, k)
            let k = k + 1
        endwhile

        let ftype = s:tlist_{i}_filetype

        let k = 1
        while k <= s:tlist_{ftype}_count
            let ttype = s:tlist_{ftype}_{k}_name
            let s:tlist_{j}_{ttype} = s:tlist_{i}_{ttype}
            let s:tlist_{j}_{ttype}_offset = s:tlist_{i}_{ttype}_offset
            let s:tlist_{j}_{ttype}_count = s:tlist_{i}_{ttype}_count
            if s:tlist_{j}_{ttype} != ''
                let l = 1
                while l <= s:tlist_{j}_{ttype}_count
                    let s:tlist_{j}_{ttype}_{l} = s:tlist_{i}_{ttype}_{l}
                    let l = l + 1
                endwhile
            endif
            let k = k + 1
        endwhile

        " As the file and tag information is copied to the new index,
        " discard the previous information
        call s:Tlist_Discard_FileInfo(i)

        let i = i + 1
    endwhile

    " Reduce the number of files displayed
    let s:tlist_file_count = s:tlist_file_count - 1

    if g:Tlist_Show_One_File
        " If the tags for only one file is displayed and if we just
        " now removed that file, then invalidate the current file idx
        if s:tlist_cur_file_idx == fidx
            let s:tlist_cur_file_idx = -1
        endif
    endif
endfunction

" Tlist_Window_Goto_Window
" Goto the taglist window
function! s:Tlist_Window_Goto_Window()
    let winnum = bufwinnr(g:TagList_title)
    if winnum != -1
        if winnr() != winnum
            call s:Tlist_Exe_Cmd_No_Acmds(winnum . 'wincmd w')
        endif
    endif
endfunction

" Tlist_Window_Create
" Create a new taglist window. If it is already open, jump to it
function! s:Tlist_Window_Create()
    call s:Tlist_Log_Msg('Tlist_Window_Create()')
    " If the window is open, jump to it
    let winnum = bufwinnr(g:TagList_title)
    if winnum != -1
        " Jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        return
    endif

    " If used with winmanager don't open windows. Winmanager will handle
    " the window/buffer management
    if s:tlist_app_name == "winmanager"
        return
    endif

    " Create a new window. If user prefers a horizontal window, then open
    " a horizontally split window. Otherwise open a vertically split
    " window
    if g:Tlist_Use_Horiz_Window
        " Open a horizontally split window
        let win_dir = 'botright'
        " Horizontal window height
        let win_size = g:Tlist_WinHeight
    else
        if s:tlist_winsize_chgd == -1
            " Open a vertically split window. Increase the window size, if
            " needed, to accomodate the new window
            if g:Tlist_Inc_Winwidth &&
                        \ &columns < (80 + g:Tlist_WinWidth)
                " Save the original window position
                let s:tlist_pre_winx = getwinposx()
                let s:tlist_pre_winy = getwinposy()

                " one extra column is needed to include the vertical split
                let &columns= &columns + g:Tlist_WinWidth + 1

                let s:tlist_winsize_chgd = 1
            else
                let s:tlist_winsize_chgd = 0
            endif
        endif

        if g:Tlist_Use_Right_Window
            " Open the window at the rightmost place
            let win_dir = 'botright vertical'
        else
            " Open the window at the leftmost place
            let win_dir = 'topleft vertical'
        endif
        let win_size = g:Tlist_WinWidth
    endif

    " If the tag listing temporary buffer already exists, then reuse it.
    " Otherwise create a new buffer
    let bufnum = bufnr(g:TagList_title)
    if bufnum == -1
        " Create a new buffer
        let wcmd = g:TagList_title
    else
        " Edit the existing buffer
        let wcmd = '+buffer' . bufnum
    endif

    " Create the taglist window
    exe 'silent! ' . win_dir . ' ' . win_size . 'split ' . wcmd

    " Save the new window position
    let s:tlist_winx = getwinposx()
    let s:tlist_winy = getwinposy()

    " Initialize the taglist window
    call s:Tlist_Window_Init()
endfunction

" Tlist_Window_Zoom
" Zoom (maximize/minimize) the taglist window
function! s:Tlist_Window_Zoom()
    if s:tlist_win_maximized
        " Restore the window back to the previous size
        if g:Tlist_Use_Horiz_Window
            exe 'resize ' . g:Tlist_WinHeight
        else
            exe 'vert resize ' . g:Tlist_WinWidth
        endif
        let s:tlist_win_maximized = 0
    else
        " Set the window size to the maximum possible without closing other
        " windows
        if g:Tlist_Use_Horiz_Window
            resize
        else
            vert resize
        endif
        let s:tlist_win_maximized = 1
    endif
endfunction

" Tlist_Ballon_Expr
" When the mouse cursor is over a tag in the taglist window, display the
" tag prototype (balloon)
function! Tlist_Ballon_Expr()
    " Get the file index
    let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(v:beval_lnum)
    if fidx == -1
        return ''
    endif

    " Get the tag output line for the current tag
    let tidx = s:Tlist_Window_Get_Tag_Index(fidx, v:beval_lnum)
    if tidx == 0
        return ''
    endif

    " Get the tag search pattern and display it
    return s:Tlist_Get_Tag_Prototype(fidx, tidx)
endfunction

" Tlist_Window_Check_Width
" Check the width of the taglist window. For horizontally split windows, the
" 'winfixheight' option is used to fix the height of the window. For
" vertically split windows, Vim doesn't support the 'winfixwidth' option. So
" need to handle window width changes from this function.
function! s:Tlist_Window_Check_Width()
    let tlist_winnr = bufwinnr(g:TagList_title)
    if tlist_winnr == -1
        return
    endif

    let width = winwidth(tlist_winnr)
    if width != g:Tlist_WinWidth
        call s:Tlist_Log_Msg("Tlist_Window_Check_Width: Changing window " .
                    \ "width from " . width . " to " . g:Tlist_WinWidth)
        let save_winnr = winnr()
        if save_winnr != tlist_winnr
            call s:Tlist_Exe_Cmd_No_Acmds(tlist_winnr . 'wincmd w')
        endif
        exe 'vert resize ' . g:Tlist_WinWidth
        if save_winnr != tlist_winnr
            call s:Tlist_Exe_Cmd_No_Acmds('wincmd p')
        endif
    endif
endfunction

" Tlist_Window_Exit_Only_Window
" If the 'Tlist_Exit_OnlyWindow' option is set, then exit Vim if only the
" taglist window is present.
function! s:Tlist_Window_Exit_Only_Window()
    " Before quitting Vim, delete the taglist buffer so that
    " the '0 mark is correctly set to the previous buffer.
    if v:version < 700
	if winbufnr(2) == -1
	    bdelete
	    quit
	endif
    else
	if winbufnr(2) == -1
	    if tabpagenr('$') == 1
		" Only one tag page is present
		bdelete
		quit
	    else
		" More than one tab page is present. Close only the current
		" tab page
		close
	    endif
	endif
    endif
endfunction

" Tlist_Window_Init
" Set the default options for the taglist window
function! s:Tlist_Window_Init()
    call s:Tlist_Log_Msg('Tlist_Window_Init()')

    " The 'readonly' option should not be set for the taglist buffer.
    " If Vim is started as "view/gview" or if the ":view" command is
    " used, then the 'readonly' option is set for all the buffers.
    " Unset it for the taglist buffer
    setlocal noreadonly

    " Set the taglist buffer filetype to taglist
    setlocal filetype=taglist

    " Define taglist window element highlighting
    syntax match TagListComment '^" .*'
    syntax match TagListFileName '^[^" ].*$'
    syntax match TagListTitle '^  \S.*$'
    syntax match TagListTagScope  '\s\[.\{-\}\]$'

    " Define the highlighting only if colors are supported
    if has('gui_running') || &t_Co > 2
        " Colors to highlight various taglist window elements
        " If user defined highlighting group exists, then use them.
        " Otherwise, use default highlight groups.
        if hlexists('MyTagListTagName')
            highlight link TagListTagName MyTagListTagName
        else
            highlight default link TagListTagName Search
        endif
        " Colors to highlight comments and titles
        if hlexists('MyTagListComment')
            highlight link TagListComment MyTagListComment
        else
            highlight clear TagListComment
            highlight default link TagListComment Comment
        endif
        if hlexists('MyTagListTitle')
            highlight link TagListTitle MyTagListTitle
        else
            highlight clear TagListTitle
            highlight default link TagListTitle Title
        endif
        if hlexists('MyTagListFileName')
            highlight link TagListFileName MyTagListFileName
        else
            highlight clear TagListFileName
            highlight default TagListFileName guibg=Grey ctermbg=darkgray
                        \ guifg=white ctermfg=white
        endif
        if hlexists('MyTagListTagScope')
            highlight link TagListTagScope MyTagListTagScope
        else
            highlight clear TagListTagScope
            highlight default link TagListTagScope Identifier
        endif
    else
        highlight default TagListTagName term=reverse cterm=reverse
    endif

    " Folding related settings
    setlocal foldenable
    setlocal foldminlines=0
    setlocal foldmethod=manual
    setlocal foldlevel=9999
    if g:Tlist_Enable_Fold_Column
        setlocal foldcolumn=3
    else
        setlocal foldcolumn=0
    endif
    setlocal foldtext=v:folddashes.getline(v:foldstart)

    if s:tlist_app_name != "winmanager"
        " Mark buffer as scratch
        silent! setlocal buftype=nofile
        if s:tlist_app_name == "none"
            silent! setlocal bufhidden=delete
        endif
        silent! setlocal noswapfile
        " Due to a bug in Vim 6.0, the winbufnr() function fails for unlisted
        " buffers. So if the taglist buffer is unlisted, multiple taglist
        " windows will be opened. This bug is fixed in Vim 6.1 and above
        if v:version >= 601
            silent! setlocal nobuflisted
        endif
    endif

    silent! setlocal nowrap

    " If the 'number' option is set in the source window, it will affect the
    " taglist window. So forcefully disable 'number' option for the taglist
    " window
    silent! setlocal nonumber

    " Use fixed height when horizontally split window is used
    if g:Tlist_Use_Horiz_Window
        if v:version >= 602
            set winfixheight
        endif
    endif
    if !g:Tlist_Use_Horiz_Window && v:version >= 700
        set winfixwidth
    endif

    " Setup balloon evaluation to display tag prototype
    if v:version >= 700 && has('balloon_eval')
        setlocal balloonexpr=Tlist_Ballon_Expr()
        set ballooneval
    endif

    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim

    " Create buffer local mappings for jumping to the tags and sorting the list
    nnoremap <buffer> <silent> <CR>
                \ :call <SID>Tlist_Window_Jump_To_Tag('useopen')<CR>
    nnoremap <buffer> <silent> o
                \ :call <SID>Tlist_Window_Jump_To_Tag('newwin')<CR>
    nnoremap <buffer> <silent> p
                \ :call <SID>Tlist_Window_Jump_To_Tag('preview')<CR>
    nnoremap <buffer> <silent> P
                \ :call <SID>Tlist_Window_Jump_To_Tag('prevwin')<CR>
    if v:version >= 700
    nnoremap <buffer> <silent> t
                \ :call <SID>Tlist_Window_Jump_To_Tag('checktab')<CR>
    nnoremap <buffer> <silent> <C-t>
                \ :call <SID>Tlist_Window_Jump_To_Tag('newtab')<CR>
    endif
    nnoremap <buffer> <silent> <2-LeftMouse>
                \ :call <SID>Tlist_Window_Jump_To_Tag('useopen')<CR>
    nnoremap <buffer> <silent> s
                \ :call <SID>Tlist_Change_Sort('cmd', 'toggle', '')<CR>
    nnoremap <buffer> <silent> + :silent! foldopen<CR>
    nnoremap <buffer> <silent> - :silent! foldclose<CR>
    nnoremap <buffer> <silent> * :silent! %foldopen!<CR>
    nnoremap <buffer> <silent> = :silent! %foldclose<CR>
    nnoremap <buffer> <silent> <kPlus> :silent! foldopen<CR>
    nnoremap <buffer> <silent> <kMinus> :silent! foldclose<CR>
    nnoremap <buffer> <silent> <kMultiply> :silent! %foldopen!<CR>
    nnoremap <buffer> <silent> <Space> :call <SID>Tlist_Window_Show_Info()<CR>
    nnoremap <buffer> <silent> u :call <SID>Tlist_Window_Update_File()<CR>
    nnoremap <buffer> <silent> d :call <SID>Tlist_Remove_File(-1, 1)<CR>
    nnoremap <buffer> <silent> x :call <SID>Tlist_Window_Zoom()<CR>
    nnoremap <buffer> <silent> [[ :call <SID>Tlist_Window_Move_To_File(-1)<CR>
    nnoremap <buffer> <silent> <BS> :call <SID>Tlist_Window_Move_To_File(-1)<CR>
    nnoremap <buffer> <silent> ]] :call <SID>Tlist_Window_Move_To_File(1)<CR>
    nnoremap <buffer> <silent> <Tab> :call <SID>Tlist_Window_Move_To_File(1)<CR>
    nnoremap <buffer> <silent> <F1> :call <SID>Tlist_Window_Toggle_Help_Text()<CR>
    nnoremap <buffer> <silent> q :close<CR>

    " Insert mode mappings
    inoremap <buffer> <silent> <CR>
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('useopen')<CR>
    " Windows needs return
    inoremap <buffer> <silent> <Return>
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('useopen')<CR>
    inoremap <buffer> <silent> o
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('newwin')<CR>
    inoremap <buffer> <silent> p
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('preview')<CR>
    inoremap <buffer> <silent> P
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('prevwin')<CR>
    if v:version >= 700
    inoremap <buffer> <silent> t
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('checktab')<CR>
    inoremap <buffer> <silent> <C-t>
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('newtab')<CR>
    endif
    inoremap <buffer> <silent> <2-LeftMouse>
                \ <C-o>:call <SID>Tlist_Window_Jump_To_Tag('useopen')<CR>
    inoremap <buffer> <silent> s
                \ <C-o>:call <SID>Tlist_Change_Sort('cmd', 'toggle', '')<CR>
    inoremap <buffer> <silent> +             <C-o>:silent! foldopen<CR>
    inoremap <buffer> <silent> -             <C-o>:silent! foldclose<CR>
    inoremap <buffer> <silent> *             <C-o>:silent! %foldopen!<CR>
    inoremap <buffer> <silent> =             <C-o>:silent! %foldclose<CR>
    inoremap <buffer> <silent> <kPlus>       <C-o>:silent! foldopen<CR>
    inoremap <buffer> <silent> <kMinus>      <C-o>:silent! foldclose<CR>
    inoremap <buffer> <silent> <kMultiply>   <C-o>:silent! %foldopen!<CR>
    inoremap <buffer> <silent> <Space>       <C-o>:call
                                    \ <SID>Tlist_Window_Show_Info()<CR>
    inoremap <buffer> <silent> u
                            \ <C-o>:call <SID>Tlist_Window_Update_File()<CR>
    inoremap <buffer> <silent> d    <C-o>:call <SID>Tlist_Remove_File(-1, 1)<CR>
    inoremap <buffer> <silent> x    <C-o>:call <SID>Tlist_Window_Zoom()<CR>
    inoremap <buffer> <silent> [[   <C-o>:call <SID>Tlist_Window_Move_To_File(-1)<CR>
    inoremap <buffer> <silent> <BS> <C-o>:call <SID>Tlist_Window_Move_To_File(-1)<CR>
    inoremap <buffer> <silent> ]]   <C-o>:call <SID>Tlist_Window_Move_To_File(1)<CR>
    inoremap <buffer> <silent> <Tab> <C-o>:call <SID>Tlist_Window_Move_To_File(1)<CR>
    inoremap <buffer> <silent> <F1>  <C-o>:call <SID>Tlist_Window_Toggle_Help_Text()<CR>
    inoremap <buffer> <silent> q    <C-o>:close<CR>

    " Map single left mouse click if the user wants this functionality
    if g:Tlist_Use_SingleClick == 1
        " Contributed by Bindu Wavell
        " attempt to perform single click mapping, it would be much
        " nicer if we could nnoremap <buffer> ... however vim does
        " not fire the <buffer> <leftmouse> when you use the mouse
        " to enter a buffer.
        let clickmap = ':if bufname("%") =~ "__Tag_List__" <bar> ' .
                    \ 'call <SID>Tlist_Window_Jump_To_Tag("useopen") ' .
                    \ '<bar> endif <CR>'
        if maparg('<leftmouse>', 'n') == ''
            " no mapping for leftmouse
            exe ':nnoremap <silent> <leftmouse> <leftmouse>' . clickmap
        else
            " we have a mapping
            let mapcmd = ':nnoremap <silent> <leftmouse> <leftmouse>'
            let mapcmd = mapcmd . substitute(substitute(
                        \ maparg('<leftmouse>', 'n'), '|', '<bar>', 'g'),
                        \ '\c^<leftmouse>', '', '')
            let mapcmd = mapcmd . clickmap
            exe mapcmd
        endif
    endif

    " Define the taglist autocommands
    augroup TagListAutoCmds
        autocmd!
        " Display the tag prototype for the tag under the cursor.
        autocmd CursorHold __Tag_List__ call s:Tlist_Window_Show_Info()
        " Highlight the current tag periodically
        autocmd CursorHold * silent call s:Tlist_Window_Highlight_Tag(
                            \ fnamemodify(bufname('%'), ':p'), line('.'), 1, 0)

        " Adjust the Vim window width when taglist window is closed
        autocmd BufUnload __Tag_List__ call s:Tlist_Post_Close_Cleanup()
        " Close the fold for this buffer when leaving the buffer
        if g:Tlist_File_Fold_Auto_Close
            autocmd BufEnter * silent
                \ call s:Tlist_Window_Open_File_Fold(expand('<abuf>'))
        endif
        " Exit Vim itself if only the taglist window is present (optional)
        if g:Tlist_Exit_OnlyWindow
	    autocmd BufEnter __Tag_List__ nested
			\ call s:Tlist_Window_Exit_Only_Window()
        endif
        if s:tlist_app_name != "winmanager" &&
                    \ !g:Tlist_Process_File_Always &&
                    \ (!has('gui_running') || !g:Tlist_Show_Menu)
            " Auto refresh the taglist window
            autocmd BufEnter * call s:Tlist_Refresh()
        endif

        if !g:Tlist_Use_Horiz_Window
            if v:version < 700
                autocmd WinEnter * call s:Tlist_Window_Check_Width()
            endif
        endif
        if v:version >= 700
            autocmd TabEnter * silent call s:Tlist_Refresh_Folds()
        endif
    augroup end

    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
endfunction

" Tlist_Window_Refresh
" Display the tags for all the files in the taglist window
function! s:Tlist_Window_Refresh()
    call s:Tlist_Log_Msg('Tlist_Window_Refresh()')
    " Set report option to a huge value to prevent informational messages
    " while deleting the lines
    let old_report = &report
    set report=99999

    " Mark the buffer as modifiable
    setlocal modifiable

    " Delete the contents of the buffer to the black-hole register
    silent! %delete _

    " As we have cleared the taglist window, mark all the files
    " as not visible
    let i = 0
    while i < s:tlist_file_count
        let s:tlist_{i}_visible = 0
        let i = i + 1
    endwhile

    if g:Tlist_Compact_Format == 0
        " Display help in non-compact mode
        call s:Tlist_Window_Display_Help()
    endif

    " Mark the buffer as not modifiable
    setlocal nomodifiable

    " Restore the report option
    let &report = old_report

    " If the tags for only one file should be displayed in the taglist
    " window, then no need to add the tags here. The bufenter autocommand
    " will add the tags for that file.
    if g:Tlist_Show_One_File
        return
    endif

    " List all the tags for the previously processed files
    " Do this only if taglist is configured to display tags for more than
    " one file. Otherwise, when Tlist_Show_One_File is configured,
    " tags for the wrong file will be displayed.
    let i = 0
    while i < s:tlist_file_count
        call s:Tlist_Window_Refresh_File(s:tlist_{i}_filename,
                    \ s:tlist_{i}_filetype)
        let i = i + 1
    endwhile

    if g:Tlist_Auto_Update
        " Add and list the tags for all buffers in the Vim buffer list
        let i = 1
        let last_bufnum = bufnr('$')
        while i <= last_bufnum
            if buflisted(i)
                let fname = fnamemodify(bufname(i), ':p')
                let ftype = s:Tlist_Get_Buffer_Filetype(i)
                " If the file doesn't support tag listing, skip it
                if !s:Tlist_Skip_File(fname, ftype)
                    call s:Tlist_Window_Refresh_File(fname, ftype)
                endif
            endif
            let i = i + 1
        endwhile
    endif

    " If Tlist_File_Fold_Auto_Close option is set, then close all the folds
    if g:Tlist_File_Fold_Auto_Close
        " Close all the folds
        silent! %foldclose
    endif

    " Move the cursor to the top of the taglist window
    normal! gg
endfunction

" Tlist_Post_Close_Cleanup()
" Close the taglist window and adjust the Vim window width
function! s:Tlist_Post_Close_Cleanup()
    call s:Tlist_Log_Msg('Tlist_Post_Close_Cleanup()')
    " Mark all the files as not visible
    let i = 0
    while i < s:tlist_file_count
        let s:tlist_{i}_visible = 0
        let i = i + 1
    endwhile

    " Remove the taglist autocommands
    silent! autocmd! TagListAutoCmds

    " Clear all the highlights
    match none

    silent! syntax clear TagListTitle
    silent! syntax clear TagListComment
    silent! syntax clear TagListTagScope

    " Remove the left mouse click mapping if it was setup initially
    if g:Tlist_Use_SingleClick
        if hasmapto('<LeftMouse>')
            nunmap <LeftMouse>
        endif
    endif

    if s:tlist_app_name != "winmanager"
    if g:Tlist_Use_Horiz_Window || g:Tlist_Inc_Winwidth == 0 ||
                \ s:tlist_winsize_chgd != 1 ||
                \ &columns < (80 + g:Tlist_WinWidth)
        " No need to adjust window width if using horizontally split taglist
        " window or if columns is less than 101 or if the user chose not to
        " adjust the window width
    else
        " If the user didn't manually move the window, then restore the window
        " position to the pre-taglist position
        if s:tlist_pre_winx != -1 && s:tlist_pre_winy != -1 &&
                    \ getwinposx() == s:tlist_winx &&
                    \ getwinposy() == s:tlist_winy
            exe 'winpos ' . s:tlist_pre_winx . ' ' . s:tlist_pre_winy
        endif

        " Adjust the Vim window width
        let &columns= &columns - (g:Tlist_WinWidth + 1)
    endif
    endif

    let s:tlist_winsize_chgd = -1

    " Reset taglist state variables
    if s:tlist_app_name == "winmanager"
        let s:tlist_app_name = "none"
    endif
    let s:tlist_window_initialized = 0
endfunction

" Tlist_Window_Refresh_File()
" List the tags defined in the specified file in a Vim window
function! s:Tlist_Window_Refresh_File(filename, ftype)
    call s:Tlist_Log_Msg('Tlist_Window_Refresh_File (' . a:filename . ')')
    " First check whether the file already exists
    let fidx = s:Tlist_Get_File_Index(a:filename)
    if fidx != -1
        let file_listed = 1
    else
        let file_listed = 0
    endif

    if !file_listed
        " Check whether this file is removed based on user request
        " If it is, then don't display the tags for this file
        if s:Tlist_User_Removed_File(a:filename)
            return
        endif
    endif

    if file_listed && s:tlist_{fidx}_visible
        " Check whether the file tags are currently valid
        if s:tlist_{fidx}_valid
            " Goto the first line in the file
            exe s:tlist_{fidx}_start

            " If the line is inside a fold, open the fold
            if foldclosed('.') != -1
                exe "silent! " . s:tlist_{fidx}_start . "," .
                            \ s:tlist_{fidx}_end . "foldopen!"
            endif
            return
        endif

        " Discard and remove the tags for this file from display
        call s:Tlist_Discard_TagInfo(fidx)
        call s:Tlist_Window_Remove_File_From_Display(fidx)
    endif

    " Process and generate a list of tags defined in the file
    if !file_listed || !s:tlist_{fidx}_valid
        let ret_fidx = s:Tlist_Process_File(a:filename, a:ftype)
        if ret_fidx == -1
            return
        endif
        let fidx = ret_fidx
    endif

    " Set report option to a huge value to prevent informational messages
    " while adding lines to the taglist window
    let old_report = &report
    set report=99999

    if g:Tlist_Show_One_File
        " Remove the previous file
        if s:tlist_cur_file_idx != -1
            call s:Tlist_Window_Remove_File_From_Display(s:tlist_cur_file_idx)
            let s:tlist_{s:tlist_cur_file_idx}_visible = 0
            let s:tlist_{s:tlist_cur_file_idx}_start = 0
            let s:tlist_{s:tlist_cur_file_idx}_end = 0
        endif
        let s:tlist_cur_file_idx = fidx
    endif

    " Mark the buffer as modifiable
    setlocal modifiable

    " Add new files to the end of the window. For existing files, add them at
    " the same line where they were previously present. If the file is not
    " visible, then add it at the end
    if s:tlist_{fidx}_start == 0 || !s:tlist_{fidx}_visible
        if g:Tlist_Compact_Format
            let s:tlist_{fidx}_start = line('$')
        else
            let s:tlist_{fidx}_start = line('$') + 1
        endif
    endif

    let s:tlist_{fidx}_visible = 1

    " Goto the line where this file should be placed
    if g:Tlist_Compact_Format
        exe s:tlist_{fidx}_start
    else
        exe s:tlist_{fidx}_start - 1
    endif

    let txt = fnamemodify(s:tlist_{fidx}_filename, ':t') . ' (' .
                \ fnamemodify(s:tlist_{fidx}_filename, ':p:h') . ')'
    if g:Tlist_Compact_Format == 0
        silent! put =txt
    else
        silent! put! =txt
        " Move to the next line
        exe line('.') + 1
    endif
    let file_start = s:tlist_{fidx}_start

    " Add the tag names grouped by tag type to the buffer with a title
    let i = 1
    let ttype_cnt = s:tlist_{a:ftype}_count
    while i <= ttype_cnt
        let ttype = s:tlist_{a:ftype}_{i}_name
        " Add the tag type only if there are tags for that type
        let fidx_ttype = 's:tlist_' . fidx . '_' . ttype
        let ttype_txt = {fidx_ttype}
        if ttype_txt != ''
            let txt = '  ' . s:tlist_{a:ftype}_{i}_fullname
            if g:Tlist_Compact_Format == 0
                let ttype_start_lnum = line('.') + 1
                silent! put =txt
            else
                let ttype_start_lnum = line('.')
                silent! put! =txt
            endif
            silent! put =ttype_txt

            let {fidx_ttype}_offset = ttype_start_lnum - file_start

            " create a fold for this tag type
            let fold_start = ttype_start_lnum
            let fold_end = fold_start + {fidx_ttype}_count
            exe fold_start . ',' . fold_end  . 'fold'

            " Adjust the cursor position
            if g:Tlist_Compact_Format == 0
                exe ttype_start_lnum + {fidx_ttype}_count
            else
                exe ttype_start_lnum + {fidx_ttype}_count + 1
            endif

            if g:Tlist_Compact_Format == 0
                " Separate the tag types by a empty line
                silent! put =''
            endif
        endif
        let i = i + 1
    endwhile

    if s:tlist_{fidx}_tag_count == 0
        if g:Tlist_Compact_Format == 0
            silent! put =''
        endif
    endif

    let s:tlist_{fidx}_end = line('.') - 1

    " Create a fold for the entire file
    exe s:tlist_{fidx}_start . ',' . s:tlist_{fidx}_end . 'fold'
    exe 'silent! ' . s:tlist_{fidx}_start . ',' .
                \ s:tlist_{fidx}_end . 'foldopen!'

    " Goto the starting line for this file,
    exe s:tlist_{fidx}_start

    if s:tlist_app_name == "winmanager"
        " To handle a bug in the winmanager plugin, add a space at the
        " last line
        call setline('$', ' ')
    endif

    " Mark the buffer as not modifiable
    setlocal nomodifiable

    " Restore the report option
    let &report = old_report

    " Update the start and end line numbers for all the files following this
    " file
    let start = s:tlist_{fidx}_start
    " include the empty line after the last line
    if g:Tlist_Compact_Format
        let end = s:tlist_{fidx}_end
    else
        let end = s:tlist_{fidx}_end + 1
    endif
    call s:Tlist_Window_Update_Line_Offsets(fidx + 1, 1, end - start + 1)

    " Now that we have updated the taglist window, update the tags
    " menu (if present)
    if g:Tlist_Show_Menu
        call s:Tlist_Menu_Update_File(1)
    endif
endfunction

" Tlist_Init_File
" Initialize the variables for a new file
function! s:Tlist_Init_File(filename, ftype)
    call s:Tlist_Log_Msg('Tlist_Init_File (' . a:filename . ')')
    " Add new files at the end of the list
    let fidx = s:tlist_file_count
    let s:tlist_file_count = s:tlist_file_count + 1
    " Add the new file name to the taglist list of file names
    let s:tlist_file_names = s:tlist_file_names . a:filename . "\n"

    " Initialize the file variables
    let s:tlist_{fidx}_filename = a:filename
    let s:tlist_{fidx}_sort_type = g:Tlist_Sort_Type
    let s:tlist_{fidx}_filetype = a:ftype
    let s:tlist_{fidx}_mtime = -1
    let s:tlist_{fidx}_start = 0
    let s:tlist_{fidx}_end = 0
    let s:tlist_{fidx}_valid = 0
    let s:tlist_{fidx}_visible = 0
    let s:tlist_{fidx}_tag_count = 0
    let s:tlist_{fidx}_menu_cmd = ''

    " Initialize the tag type variables
    let i = 1
    while i <= s:tlist_{a:ftype}_count
        let ttype = s:tlist_{a:ftype}_{i}_name
        let s:tlist_{fidx}_{ttype} = ''
        let s:tlist_{fidx}_{ttype}_offset = 0
        let s:tlist_{fidx}_{ttype}_count = 0
        let i = i + 1
    endwhile

    return fidx
endfunction

" Tlist_Get_Tag_Type_By_Tag
" Return the tag type for the specified tag index
function! s:Tlist_Get_Tag_Type_By_Tag(fidx, tidx)
    let ttype_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_type'

    " Already parsed and have the tag name
    if exists(ttype_var)
        return {ttype_var}
    endif

    let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
    let {ttype_var} = s:Tlist_Extract_Tagtype(tag_line)

    return {ttype_var}
endfunction

" Tlist_Get_Tag_Prototype
function! s:Tlist_Get_Tag_Prototype(fidx, tidx)
    let tproto_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_proto'

    " Already parsed and have the tag prototype
    if exists(tproto_var)
        return {tproto_var}
    endif

    " Parse and extract the tag prototype
    let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
    let start = stridx(tag_line, '/^') + 2
    let end = stridx(tag_line, '/;"' . "\t")
    if tag_line[end - 1] == '$'
        let end = end -1
    endif
    let tag_proto = strpart(tag_line, start, end - start)
    let {tproto_var} = substitute(tag_proto, '\s*', '', '')

    return {tproto_var}
endfunction

" Tlist_Get_Tag_SearchPat
function! s:Tlist_Get_Tag_SearchPat(fidx, tidx)
    let tpat_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_searchpat'

    " Already parsed and have the tag search pattern
    if exists(tpat_var)
        return {tpat_var}
    endif

    " Parse and extract the tag search pattern
    let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
    let start = stridx(tag_line, '/^') + 2
    let end = stridx(tag_line, '/;"' . "\t")
    if tag_line[end - 1] == '$'
        let end = end -1
    endif
    let {tpat_var} = '\V\^' . strpart(tag_line, start, end - start) .
                        \ (tag_line[end] == '$' ? '\$' : '')

    return {tpat_var}
endfunction

" Tlist_Get_Tag_Linenum
" Return the tag line number, given the tag index
function! s:Tlist_Get_Tag_Linenum(fidx, tidx)
    let tline_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_linenum'

    " Already parsed and have the tag line number
    if exists(tline_var)
        return {tline_var}
    endif

    " Parse and extract the tag line number
    let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
    let start = strridx(tag_line, 'line:') + 5
    let end = strridx(tag_line, "\t")
    if end < start
        let {tline_var} = strpart(tag_line, start) + 0
    else
        let {tline_var} = strpart(tag_line, start, end - start) + 0
    endif

    return {tline_var}
endfunction

" Tlist_Parse_Tagline
" Parse a tag line from the ctags output. Separate the tag output based on the
" tag type and store it in the tag type variable.
" The format of each line in the ctags output is:
"
"     tag_name<TAB>file_name<TAB>ex_cmd;"<TAB>extension_fields
"
function! s:Tlist_Parse_Tagline(tag_line)
    if a:tag_line == ''
        " Skip empty lines
        return
    endif

    " Extract the tag type
    let ttype = s:Tlist_Extract_Tagtype(a:tag_line)

    " Make sure the tag type is a valid and supported one
    if ttype == '' || stridx(s:ctags_flags, ttype) == -1
        " Line is not in proper tags format or Tag type is not supported
        return
    endif

    " Update the total tag count
    let s:tidx = s:tidx + 1

    " The following variables are used to optimize this code.  Vim is slow in
    " using curly brace names. To reduce the amount of processing needed, the
    " curly brace variables are pre-processed here
    let fidx_tidx = 's:tlist_' . s:fidx . '_' . s:tidx
    let fidx_ttype = 's:tlist_' . s:fidx . '_' . ttype

    " Update the count of this tag type
    let ttype_idx = {fidx_ttype}_count + 1
    let {fidx_ttype}_count = ttype_idx

    " Store the ctags output for this tag
    let {fidx_tidx}_tag = a:tag_line

    " Store the tag index and the tag type index (back pointers)
    let {fidx_ttype}_{ttype_idx} = s:tidx
    let {fidx_tidx}_ttype_idx = ttype_idx

    " Extract the tag name
    let tag_name = strpart(a:tag_line, 0, stridx(a:tag_line, "\t"))

    " Extract the tag scope/prototype
    if g:Tlist_Display_Prototype
        let ttxt = '    ' . s:Tlist_Get_Tag_Prototype(s:fidx, s:tidx)
    else
        let ttxt = '    ' . tag_name

        " Add the tag scope, if it is available and is configured. Tag
        " scope is the last field after the 'line:<num>\t' field
        if g:Tlist_Display_Tag_Scope
            let tag_scope = s:Tlist_Extract_Tag_Scope(a:tag_line)
            if tag_scope != ''
                let ttxt = ttxt . ' [' . tag_scope . ']'
            endif
        endif
    endif

    " Add this tag to the tag type variable
    let {fidx_ttype} = {fidx_ttype} . ttxt . "\n"

    " Save the tag name
    let {fidx_tidx}_tag_name = tag_name
endfunction

" Tlist_Process_File
" Get the list of tags defined in the specified file and store them
" in Vim variables. Returns the file index where the tags are stored.
function! s:Tlist_Process_File(filename, ftype)
    call s:Tlist_Log_Msg('Tlist_Process_File (' . a:filename . ', ' .
                \ a:ftype . ')')
    " Check whether this file is supported
    if s:Tlist_Skip_File(a:filename, a:ftype)
        return -1
    endif

    " If the tag types for this filetype are not yet created, then create
    " them now
    let var = 's:tlist_' . a:ftype . '_count'
    if !exists(var)
        if s:Tlist_FileType_Init(a:ftype) == 0
            return -1
        endif
    endif

    " If this file is already processed, then use the cached values
    let fidx = s:Tlist_Get_File_Index(a:filename)
    if fidx == -1
        " First time, this file is loaded
        let fidx = s:Tlist_Init_File(a:filename, a:ftype)
    else
        " File was previously processed. Discard the tag information
        call s:Tlist_Discard_TagInfo(fidx)
    endif

    let s:tlist_{fidx}_valid = 1

    " Exuberant ctags arguments to generate a tag list
    let ctags_args = ' -f - --format=2 --excmd=pattern --fields=nks '

    " Form the ctags argument depending on the sort type
    if s:tlist_{fidx}_sort_type == 'name'
        let ctags_args = ctags_args . '--sort=yes'
    else
        let ctags_args = ctags_args . '--sort=no'
    endif

    " Add the filetype specific arguments
    let ctags_args = ctags_args . ' ' . s:tlist_{a:ftype}_ctags_args

    " Ctags command to produce output with regexp for locating the tags
    let ctags_cmd = g:Tlist_Ctags_Cmd . ctags_args
    let ctags_cmd = ctags_cmd . ' "' . a:filename . '"'

    if &shellxquote == '"'
        " Double-quotes within double-quotes will not work in the
        " command-line.If the 'shellxquote' option is set to double-quotes,
        " then escape the double-quotes in the ctags command-line.
        let ctags_cmd = escape(ctags_cmd, '"')
    endif

    " In Windows 95, if not using cygwin, disable the 'shellslash'
    " option. Otherwise, this will cause problems when running the
    " ctags command.
    if has('win95') && !has('win32unix')
        let old_shellslash = &shellslash
        set noshellslash
    endif

    if has('win32') && !has('win32unix') && !has('win95')
                \ && (&shell =~ 'cmd.exe')
        " Windows does not correctly deal with commands that have more than 1
        " set of double quotes.  It will strip them all resulting in:
        " 'C:\Program' is not recognized as an internal or external command
        " operable program or batch file.  To work around this, place the
        " command inside a batch file and call the batch file.
        " Do this only on Win2K, WinXP and above.
        " Contributed by: David Fishburn.
        let s:taglist_tempfile = fnamemodify(tempname(), ':h') .
                    \ '\taglist.cmd'
        exe 'redir! > ' . s:taglist_tempfile
        silent echo ctags_cmd
        redir END

        call s:Tlist_Log_Msg('Cmd inside batch file: ' . ctags_cmd)
        let ctags_cmd = '"' . s:taglist_tempfile . '"'
    endif

    call s:Tlist_Log_Msg('Cmd: ' . ctags_cmd)

    " Run ctags and get the tag list
    let cmd_output = system(ctags_cmd)

    " Restore the value of the 'shellslash' option.
    if has('win95') && !has('win32unix')
        let &shellslash = old_shellslash
    endif

    if exists('s:taglist_tempfile')
        " Delete the temporary cmd file created on MS-Windows
        call delete(s:taglist_tempfile)
    endif

    " Handle errors
    if v:shell_error
        let msg = "Taglist: Failed to generate tags for " . a:filename
        call s:Tlist_Warning_Msg(msg)
        if cmd_output != ''
            call s:Tlist_Warning_Msg(cmd_output)
        endif
        return fidx
    endif

    " Store the modification time for the file
    let s:tlist_{fidx}_mtime = getftime(a:filename)

    " No tags for current file
    if cmd_output == ''
        call s:Tlist_Log_Msg('No tags defined in ' . a:filename)
        return fidx
    endif

    call s:Tlist_Log_Msg('Generated tags information for ' . a:filename)

    if v:version > 601
        " The following script local variables are used by the
        " Tlist_Parse_Tagline() function.
        let s:ctags_flags = s:tlist_{a:ftype}_ctags_flags
        let s:fidx = fidx
        let s:tidx = 0

        " Process the ctags output one line at a time.  The substitute()
        " command is used to parse the tag lines instead of using the
        " matchstr()/stridx()/strpart() functions for performance reason
        call substitute(cmd_output, "\\([^\n]\\+\\)\n",
                    \ '\=s:Tlist_Parse_Tagline(submatch(1))', 'g')

        " Save the number of tags for this file
        let s:tlist_{fidx}_tag_count = s:tidx

        " The following script local variables are no longer needed
        unlet! s:ctags_flags
        unlet! s:tidx
        unlet! s:fidx
    else
        " Due to a bug in Vim earlier than version 6.1,
        " we cannot use substitute() to parse the ctags output.
        " Instead the slow str*() functions are used
        let ctags_flags = s:tlist_{a:ftype}_ctags_flags
        let tidx = 0

        while cmd_output != ''
            " Extract one line at a time
            let idx = stridx(cmd_output, "\n")
            let one_line = strpart(cmd_output, 0, idx)
            " Remove the line from the tags output
            let cmd_output = strpart(cmd_output, idx + 1)

            if one_line == ''
                " Line is not in proper tags format
                continue
            endif

            " Extract the tag type
            let ttype = s:Tlist_Extract_Tagtype(one_line)

            " Make sure the tag type is a valid and supported one
            if ttype == '' || stridx(ctags_flags, ttype) == -1
                " Line is not in proper tags format or Tag type is not
                " supported
                continue
            endif

            " Update the total tag count
            let tidx = tidx + 1

            " The following variables are used to optimize this code.  Vim is
            " slow in using curly brace names. To reduce the amount of
            " processing needed, the curly brace variables are pre-processed
            " here
            let fidx_tidx = 's:tlist_' . fidx . '_' . tidx
            let fidx_ttype = 's:tlist_' . fidx . '_' . ttype

            " Update the count of this tag type
            let ttype_idx = {fidx_ttype}_count + 1
            let {fidx_ttype}_count = ttype_idx

            " Store the ctags output for this tag
            let {fidx_tidx}_tag = one_line

            " Store the tag index and the tag type index (back pointers)
            let {fidx_ttype}_{ttype_idx} = tidx
            let {fidx_tidx}_ttype_idx = ttype_idx

            " Extract the tag name
            let tag_name = strpart(one_line, 0, stridx(one_line, "\t"))

            " Extract the tag scope/prototype
            if g:Tlist_Display_Prototype
                let ttxt = '    ' . s:Tlist_Get_Tag_Prototype(fidx, tidx)
            else
                let ttxt = '    ' . tag_name

                " Add the tag scope, if it is available and is configured. Tag
                " scope is the last field after the 'line:<num>\t' field
                if g:Tlist_Display_Tag_Scope
                    let tag_scope = s:Tlist_Extract_Tag_Scope(one_line)
                    if tag_scope != ''
                        let ttxt = ttxt . ' [' . tag_scope . ']'
                    endif
                endif
            endif

            " Add this tag to the tag type variable
            let {fidx_ttype} = {fidx_ttype} . ttxt . "\n"

            " Save the tag name
            let {fidx_tidx}_tag_name = tag_name
        endwhile

        " Save the number of tags for this file
        let s:tlist_{fidx}_tag_count = tidx
    endif

    call s:Tlist_Log_Msg('Processed ' . s:tlist_{fidx}_tag_count . 
                \ ' tags in ' . a:filename)

    return fidx
endfunction

" Tlist_Update_File
" Update the tags for a file (if needed)
function! Tlist_Update_File(filename, ftype)
    call s:Tlist_Log_Msg('Tlist_Update_File (' . a:filename . ')')
    " If the file doesn't support tag listing, skip it
    if s:Tlist_Skip_File(a:filename, a:ftype)
        return
    endif

    " Convert the file name to a full path
    let fname = fnamemodify(a:filename, ':p')

    " First check whether the file already exists
    let fidx = s:Tlist_Get_File_Index(fname)

    if fidx != -1 && s:tlist_{fidx}_valid
        " File exists and the tags are valid
        " Check whether the file was modified after the last tags update
        " If it is modified, then update the tags
        if s:tlist_{fidx}_mtime == getftime(fname)
            return
        endif
    else
        " If the tags were removed previously based on a user request,
        " as we are going to update the tags (based on the user request),
        " remove the filename from the deleted list
        call s:Tlist_Update_Remove_List(fname, 0)
    endif

    " If the taglist window is opened, update it
    let winnum = bufwinnr(g:TagList_title)
    if winnum == -1
        " Taglist window is not present. Just update the taglist
        " and return
        call s:Tlist_Process_File(fname, a:ftype)
    else
        if g:Tlist_Show_One_File && s:tlist_cur_file_idx != -1
            " If tags for only one file are displayed and we are not
            " updating the tags for that file, then no need to
            " refresh the taglist window. Otherwise, the taglist
            " window should be updated.
            if s:tlist_{s:tlist_cur_file_idx}_filename != fname
                call s:Tlist_Process_File(fname, a:ftype)
                return
            endif
        endif

        " Save the current window number
        let save_winnr = winnr()

        " Goto the taglist window
        call s:Tlist_Window_Goto_Window()

        " Save the cursor position
        let save_line = line('.')
        let save_col = col('.')

        " Update the taglist window
        call s:Tlist_Window_Refresh_File(fname, a:ftype)

        " Restore the cursor position
        if v:version >= 601
            call cursor(save_line, save_col)
        else
            exe save_line
            exe 'normal! ' . save_col . '|'
        endif

        if winnr() != save_winnr
            " Go back to the original window
            call s:Tlist_Exe_Cmd_No_Acmds(save_winnr . 'wincmd w')
        endif
    endif

    " Update the taglist menu
    if g:Tlist_Show_Menu
        call s:Tlist_Menu_Update_File(1)
    endif
endfunction

" Tlist_Window_Close
" Close the taglist window
function! s:Tlist_Window_Close()
    call s:Tlist_Log_Msg('Tlist_Window_Close()')
    " Make sure the taglist window exists
    let winnum = bufwinnr(g:TagList_title)
    if winnum == -1
        call s:Tlist_Warning_Msg('Error: Taglist window is not open')
        return
    endif

    if winnr() == winnum
        " Already in the taglist window. Close it and return
        if winbufnr(2) != -1
            " If a window other than the taglist window is open,
            " then only close the taglist window.
            close
        endif
    else
        " Goto the taglist window, close it and then come back to the
        " original window
        let curbufnr = bufnr('%')
        exe winnum . 'wincmd w'
        close
        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(curbufnr)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
endfunction

" Tlist_Window_Mark_File_Window
" Mark the current window as the file window to use when jumping to a tag.
" Only if the current window is a non-plugin, non-preview and non-taglist
" window
function! s:Tlist_Window_Mark_File_Window()
    if getbufvar('%', '&buftype') == '' && !&previewwindow
        let w:tlist_file_window = "yes"
    endif
endfunction

" Tlist_Window_Open
" Open and refresh the taglist window
function! s:Tlist_Window_Open()
    call s:Tlist_Log_Msg('Tlist_Window_Open()')
    " If the window is open, jump to it
    let winnum = bufwinnr(g:TagList_title)
    if winnum != -1
        " Jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        return
    endif

    if s:tlist_app_name == "winmanager"
        " Taglist plugin is no longer part of the winmanager app
        let s:tlist_app_name = "none"
    endif

    " Get the filename and filetype for the specified buffer
    let curbuf_name = fnamemodify(bufname('%'), ':p')
    let curbuf_ftype = s:Tlist_Get_Buffer_Filetype('%')
    let cur_lnum = line('.')

    " Mark the current window as the desired window to open a file when a tag
    " is selected.
    call s:Tlist_Window_Mark_File_Window()

    " Open the taglist window
    call s:Tlist_Window_Create()

    call s:Tlist_Window_Refresh()

    if g:Tlist_Show_One_File
        " Add only the current buffer and file
        "
        " If the file doesn't support tag listing, skip it
        if !s:Tlist_Skip_File(curbuf_name, curbuf_ftype)
            call s:Tlist_Window_Refresh_File(curbuf_name, curbuf_ftype)
        endif
    endif

    if g:Tlist_File_Fold_Auto_Close
        " Open the fold for the current file, as all the folds in
        " the taglist window are closed
        let fidx = s:Tlist_Get_File_Index(curbuf_name)
        if fidx != -1
            exe "silent! " . s:tlist_{fidx}_start . "," .
                        \ s:tlist_{fidx}_end . "foldopen!"
        endif
    endif

    " Highlight the current tag
    call s:Tlist_Window_Highlight_Tag(curbuf_name, cur_lnum, 1, 1)
endfunction

" Tlist_Window_Toggle()
" Open or close a taglist window
function! s:Tlist_Window_Toggle()
    call s:Tlist_Log_Msg('Tlist_Window_Toggle()')
    " If taglist window is open then close it.
    let winnum = bufwinnr(g:TagList_title)
    if winnum != -1
        call s:Tlist_Window_Close()
        return
    endif

    call s:Tlist_Window_Open()

    " Go back to the original window, if Tlist_GainFocus_On_ToggleOpen is not
    " set
    if !g:Tlist_GainFocus_On_ToggleOpen
        call s:Tlist_Exe_Cmd_No_Acmds('wincmd p')
    endif

    " Update the taglist menu
    if g:Tlist_Show_Menu
        call s:Tlist_Menu_Update_File(0)
    endif
endfunction

" Tlist_Process_Filelist
" Process multiple files. Each filename is separated by "\n"
" Returns the number of processed files
function! s:Tlist_Process_Filelist(file_names)
    let flist = a:file_names

    " Enable lazy screen updates
    let old_lazyredraw = &lazyredraw
    set lazyredraw

    " Keep track of the number of processed files
    let fcnt = 0

    " Process one file at a time
    while flist != ''
        let nl_idx = stridx(flist, "\n")
        let one_file = strpart(flist, 0, nl_idx)

        " Remove the filename from the list
        let flist = strpart(flist, nl_idx + 1)

        if one_file == ''
            continue
        endif

        " Skip directories
        if isdirectory(one_file)
            continue
        endif

        let ftype = s:Tlist_Detect_Filetype(one_file)

        echon "\r                                                              "
        echon "\rProcessing tags for " . fnamemodify(one_file, ':p:t')

        let fcnt = fcnt + 1

        call Tlist_Update_File(one_file, ftype)
    endwhile

    " Clear the displayed informational messages
    echon "\r                                                            "

    " Restore the previous state
    let &lazyredraw = old_lazyredraw

    return fcnt
endfunction

" Tlist_Process_Dir
" Process the files in a directory matching the specified pattern
function! s:Tlist_Process_Dir(dir_name, pat)
    let flist = glob(a:dir_name . '/' . a:pat) . "\n"

    let fcnt = s:Tlist_Process_Filelist(flist)

    let len = strlen(a:dir_name)
    if a:dir_name[len - 1] == '\' || a:dir_name[len - 1] == '/'
        let glob_expr = a:dir_name . '*'
    else
        let glob_expr = a:dir_name . '/*'
    endif
    let all_files = glob(glob_expr) . "\n"

    while all_files != ''
        let nl_idx = stridx(all_files, "\n")
        let one_file = strpart(all_files, 0, nl_idx)

        let all_files = strpart(all_files, nl_idx + 1)
        if one_file == ''
            continue
        endif

        " Skip non-directory names
        if !isdirectory(one_file)
            continue
        endif

        echon "\r                                                              "
        echon "\rProcessing files in directory " . fnamemodify(one_file, ':t')
        let fcnt = fcnt + s:Tlist_Process_Dir(one_file, a:pat)
    endwhile

    return fcnt
endfunction

" Tlist_Add_Files_Recursive
" Add files recursively from a directory
function! s:Tlist_Add_Files_Recursive(dir, ...)
    let dir_name = fnamemodify(a:dir, ':p')
    if !isdirectory(dir_name)
        call s:Tlist_Warning_Msg('Error: ' . dir_name . ' is not a directory')
        return
    endif

    if a:0 == 1
        " User specified file pattern
        let pat = a:1
    else
        " Default file pattern
        let pat = '*'
    endif

    echon "\r                                                              "
    echon "\rProcessing files in directory " . fnamemodify(dir_name, ':t')
    let fcnt = s:Tlist_Process_Dir(dir_name, pat)

    echon "\rAdded " . fcnt . " files to the taglist"
endfunction

" Tlist_Add_Files
" Add the specified list of files to the taglist
function! s:Tlist_Add_Files(...)
    let flist = ''
    let i = 1

    " Get all the files matching the file patterns supplied as argument
    while i <= a:0
        let flist = flist . glob(a:{i}) . "\n"
        let i = i + 1
    endwhile

    if flist == ''
        call s:Tlist_Warning_Msg('Error: No matching files are found')
        return
    endif

    let fcnt = s:Tlist_Process_Filelist(flist)
    echon "\rAdded " . fcnt . " files to the taglist"
endfunction

" Tlist_Extract_Tagtype
" Extract the tag type from the tag text
function! s:Tlist_Extract_Tagtype(tag_line)
    " The tag type is after the tag prototype field. The prototype field
    " ends with the /;"\t string. We add 4 at the end to skip the characters
    " in this special string..
    let start = strridx(a:tag_line, '/;"' . "\t") + 4
    let end = strridx(a:tag_line, 'line:') - 1
    let ttype = strpart(a:tag_line, start, end - start)

    return ttype
endfunction

" Tlist_Extract_Tag_Scope
" Extract the tag scope from the tag text
function! s:Tlist_Extract_Tag_Scope(tag_line)
    let start = strridx(a:tag_line, 'line:')
    let end = strridx(a:tag_line, "\t")
    if end <= start
        return ''
    endif

    let tag_scope = strpart(a:tag_line, end + 1)
    let tag_scope = strpart(tag_scope, stridx(tag_scope, ':') + 1)

    return tag_scope
endfunction

" Tlist_Refresh()
" Refresh the taglist
function! s:Tlist_Refresh()
    call s:Tlist_Log_Msg('Tlist_Refresh (Skip_Refresh = ' .
                \ s:Tlist_Skip_Refresh . ', ' . bufname('%') . ')')
    " If we are entering the buffer from one of the taglist functions, then
    " no need to refresh the taglist window again.
    if s:Tlist_Skip_Refresh
        " We still need to update the taglist menu
        if g:Tlist_Show_Menu
            call s:Tlist_Menu_Update_File(0)
        endif
        return
    endif

    " If part of the winmanager plugin and not configured to process
    " tags always and not configured to display the tags menu, then return
    if (s:tlist_app_name == 'winmanager') && !g:Tlist_Process_File_Always
                \ && !g:Tlist_Show_Menu
        return
    endif

    " Skip buffers with 'buftype' set to nofile, nowrite, quickfix or help
    if &buftype != ''
        return
    endif

    let filename = fnamemodify(bufname('%'), ':p')
    let ftype = s:Tlist_Get_Buffer_Filetype('%')

    " If the file doesn't support tag listing, skip it
    if s:Tlist_Skip_File(filename, ftype)
        return
    endif

    let tlist_win = bufwinnr(g:TagList_title)

    " If the taglist window is not opened and not configured to process
    " tags always and not displaying the tags menu, then return
    if tlist_win == -1 && !g:Tlist_Process_File_Always && !g:Tlist_Show_Menu
        return
    endif

    let fidx = s:Tlist_Get_File_Index(filename)
    if fidx == -1
        " Check whether this file is removed based on user request
        " If it is, then don't display the tags for this file
        if s:Tlist_User_Removed_File(filename)
            return
        endif

        " If the taglist should not be auto updated, then return
        if !g:Tlist_Auto_Update
            return
        endif
    endif

    let cur_lnum = line('.')

    if fidx == -1
        " Update the tags for the file
        let fidx = s:Tlist_Process_File(filename, ftype)
    else
        let mtime = getftime(filename)
        if s:tlist_{fidx}_mtime != mtime
            " Invalidate the tags listed for this file
            let s:tlist_{fidx}_valid = 0

            " Update the taglist and the window
            call Tlist_Update_File(filename, ftype)

            " Store the new file modification time
            let s:tlist_{fidx}_mtime = mtime
        endif
    endif

    " Update the taglist window
    if tlist_win != -1
        " Disable screen updates
        let old_lazyredraw = &lazyredraw
        set nolazyredraw

        " Save the current window number
        let save_winnr = winnr()

        " Goto the taglist window
        call s:Tlist_Window_Goto_Window()

        if !g:Tlist_Auto_Highlight_Tag || !g:Tlist_Highlight_Tag_On_BufEnter
            " Save the cursor position
            let save_line = line('.')
            let save_col = col('.')
        endif

        " Update the taglist window
        call s:Tlist_Window_Refresh_File(filename, ftype)

        " Open the fold for the file
        exe "silent! " . s:tlist_{fidx}_start . "," .
                    \ s:tlist_{fidx}_end . "foldopen!"

        if g:Tlist_Highlight_Tag_On_BufEnter && g:Tlist_Auto_Highlight_Tag
            if g:Tlist_Show_One_File && s:tlist_cur_file_idx != fidx
                " If displaying tags for only one file in the taglist
                " window and about to display the tags for a new file,
                " then center the current tag line for the new file
                let center_tag_line = 1
            else
                let center_tag_line = 0
            endif

            " Highlight the current tag
            call s:Tlist_Window_Highlight_Tag(filename, cur_lnum, 1, center_tag_line)
        else
            " Restore the cursor position
            if v:version >= 601
                call cursor(save_line, save_col)
            else
                exe save_line
                exe 'normal! ' . save_col . '|'
            endif
        endif

        " Jump back to the original window
        if save_winnr != winnr()
            call s:Tlist_Exe_Cmd_No_Acmds(save_winnr . 'wincmd w')
        endif

        " Restore screen updates
        let &lazyredraw = old_lazyredraw
    endif

    " Update the taglist menu
    if g:Tlist_Show_Menu
        call s:Tlist_Menu_Update_File(0)
    endif
endfunction

" Tlist_Change_Sort()
" Change the sort order of the tag listing
" caller == 'cmd', command used in the taglist window
" caller == 'menu', taglist menu
" action == 'toggle', toggle sort from name to order and vice versa
" action == 'set', set the sort order to sort_type
function! s:Tlist_Change_Sort(caller, action, sort_type)
    call s:Tlist_Log_Msg('Tlist_Change_Sort (caller = ' . a:caller .
            \ ', action = ' . a:action . ', sort_type = ' . a:sort_type . ')')
    if a:caller == 'cmd'
        let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(line('.'))
        if fidx == -1
            return
        endif

        " Remove the previous highlighting
        match none
    elseif a:caller == 'menu'
        let fidx = s:Tlist_Get_File_Index(fnamemodify(bufname('%'), ':p'))
        if fidx == -1
            return
        endif
    endif

    if a:action == 'toggle'
        let sort_type = s:tlist_{fidx}_sort_type

        " Toggle the sort order from 'name' to 'order' and vice versa
        if sort_type == 'name'
            let s:tlist_{fidx}_sort_type = 'order'
        else
            let s:tlist_{fidx}_sort_type = 'name'
        endif
    else
        let s:tlist_{fidx}_sort_type = a:sort_type
    endif

    " Invalidate the tags listed for this file
    let s:tlist_{fidx}_valid = 0

    if a:caller  == 'cmd'
        " Save the current line for later restoration
        let curline = '\V\^' . getline('.') . '\$'

        call s:Tlist_Window_Refresh_File(s:tlist_{fidx}_filename,
                    \   s:tlist_{fidx}_filetype)

        exe s:tlist_{fidx}_start . ',' . s:tlist_{fidx}_end . 'foldopen!'

        " Go back to the cursor line before the tag list is sorted
        call search(curline, 'w')

        call s:Tlist_Menu_Update_File(1)
    else
        call s:Tlist_Menu_Remove_File()

        call s:Tlist_Refresh()
    endif
endfunction

" Tlist_Update_Current_File()
" Update taglist for the current buffer by regenerating the tag list
" Contributed by WEN Guopeng.
function! s:Tlist_Update_Current_File()
    call s:Tlist_Log_Msg('Tlist_Update_Current_File()')
    if winnr() == bufwinnr(g:TagList_title)
        " In the taglist window. Update the current file
        call s:Tlist_Window_Update_File()
    else
        " Not in the taglist window. Update the current buffer
        let filename = fnamemodify(bufname('%'), ':p')
        let fidx = s:Tlist_Get_File_Index(filename)
        if fidx != -1
            let s:tlist_{fidx}_valid = 0
        endif
        let ft = s:Tlist_Get_Buffer_Filetype('%')
        call Tlist_Update_File(filename, ft)
    endif
endfunction

" Tlist_Window_Update_File()
" Update the tags displayed in the taglist window
function! s:Tlist_Window_Update_File()
    call s:Tlist_Log_Msg('Tlist_Window_Update_File()')
    let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(line('.'))
    if fidx == -1
        return
    endif

    " Remove the previous highlighting
    match none

    " Save the current line for later restoration
    let curline = '\V\^' . getline('.') . '\$'

    let s:tlist_{fidx}_valid = 0

    " Update the taglist window
    call s:Tlist_Window_Refresh_File(s:tlist_{fidx}_filename,
                \ s:tlist_{fidx}_filetype)

    exe s:tlist_{fidx}_start . ',' . s:tlist_{fidx}_end . 'foldopen!'

    " Go back to the tag line before the list is updated
    call search(curline, 'w')
endfunction

" Tlist_Window_Get_Tag_Type_By_Linenum()
" Return the tag type index for the specified line in the taglist window
function! s:Tlist_Window_Get_Tag_Type_By_Linenum(fidx, lnum)
    let ftype = s:tlist_{a:fidx}_filetype

    " Determine to which tag type the current line number belongs to using the
    " tag type start line number and the number of tags in a tag type
    let i = 1
    while i <= s:tlist_{ftype}_count
        let ttype = s:tlist_{ftype}_{i}_name
        let start_lnum =
                    \ s:tlist_{a:fidx}_start + s:tlist_{a:fidx}_{ttype}_offset
        let end =  start_lnum + s:tlist_{a:fidx}_{ttype}_count
        if a:lnum >= start_lnum && a:lnum <= end
            break
        endif
        let i = i + 1
    endwhile

    " Current line doesn't belong to any of the displayed tag types
    if i > s:tlist_{ftype}_count
        return ''
    endif

    return ttype
endfunction

" Tlist_Window_Get_Tag_Index()
" Return the tag index for the specified line in the taglist window
function! s:Tlist_Window_Get_Tag_Index(fidx, lnum)
    let ttype = s:Tlist_Window_Get_Tag_Type_By_Linenum(a:fidx, a:lnum)

    " Current line doesn't belong to any of the displayed tag types
    if ttype == ''
        return 0
    endif

    " Compute the index into the displayed tags for the tag type
    let ttype_lnum = s:tlist_{a:fidx}_start + s:tlist_{a:fidx}_{ttype}_offset
    let tidx = a:lnum - ttype_lnum
    if tidx == 0
        return 0
    endif

    " Get the corresponding tag line and return it
    return s:tlist_{a:fidx}_{ttype}_{tidx}
endfunction

" Tlist_Window_Highlight_Line
" Highlight the current line
function! s:Tlist_Window_Highlight_Line()
    " Clear previously selected name
    match none

    " Highlight the current line
    if g:Tlist_Display_Prototype == 0
        let pat = '/\%' . line('.') . 'l\s\+\zs.*/'
    else
        let pat = '/\%' . line('.') . 'l.*/'
    endif

    exe 'match TagListTagName ' . pat
endfunction

" Tlist_Window_Open_File
" Open the specified file in either a new window or an existing window
" and place the cursor at the specified tag pattern
function! s:Tlist_Window_Open_File(win_ctrl, filename, tagpat)
    call s:Tlist_Log_Msg('Tlist_Window_Open_File (' . a:filename . ',' .
                \ a:win_ctrl . ')')
    let prev_Tlist_Skip_Refresh = s:Tlist_Skip_Refresh
    let s:Tlist_Skip_Refresh = 1

    if s:tlist_app_name == "winmanager"
        " Let the winmanager edit the file
        call WinManagerFileEdit(a:filename, a:win_ctrl == 'newwin')
    else

    if a:win_ctrl == 'newtab'
        " Create a new tab
        exe 'tabnew ' . escape(a:filename, ' ')
        " Open the taglist window in the new tab
        call s:Tlist_Window_Open()
    endif

    if a:win_ctrl == 'checktab'
        " Check whether the file is present in any of the tabs.
        " If the file is present in the current tab, then use the
        " current tab.
        if bufwinnr(a:filename) != -1
            let file_present_in_tab = 1
            let i = tabpagenr()
        else
            let i = 1
            let bnum = bufnr(a:filename)
            let file_present_in_tab = 0
            while i <= tabpagenr('$')
                if index(tabpagebuflist(i), bnum) != -1
                    let file_present_in_tab = 1
                    break
                endif
                let i += 1
            endwhile
        endif

        if file_present_in_tab
            " Goto the tab containing the file
            exe 'tabnext ' . i
        else
            " Open a new tab
            exe 'tabnew ' . escape(a:filename, ' ')

            " Open the taglist window
            call s:Tlist_Window_Open()
        endif
    endif

    let winnum = -1
    if a:win_ctrl == 'prevwin'
        " Open the file in the previous window, if it is usable
        let cur_win = winnr()
        wincmd p
        if &buftype == '' && !&previewwindow
            exe "edit " . escape(a:filename, ' ')
            let winnum = winnr()
        else
            " Previous window is not usable
            exe cur_win . 'wincmd w'
        endif
    endif

    " Goto the window containing the file.  If the window is not there, open a
    " new window
    if winnum == -1
        let winnum = bufwinnr(a:filename)
    endif

    if winnum == -1
        " Locate the previously used window for opening a file
        let fwin_num = 0
        let first_usable_win = 0

        let i = 1
        let bnum = winbufnr(i)
        while bnum != -1
            if getwinvar(i, 'tlist_file_window') == 'yes'
                let fwin_num = i
                break
            endif
            if first_usable_win == 0 &&
                        \ getbufvar(bnum, '&buftype') == '' &&
                        \ !getwinvar(i, '&previewwindow')
                " First non-taglist, non-plugin and non-preview window
                let first_usable_win = i
            endif
            let i = i + 1
            let bnum = winbufnr(i)
        endwhile

        " If a previously used window is not found, then use the first
        " non-taglist window
        if fwin_num == 0
            let fwin_num = first_usable_win
        endif

        if fwin_num != 0
            " Jump to the file window
            exe fwin_num . "wincmd w"

            " If the user asked to jump to the tag in a new window, then split
            " the existing window into two.
            if a:win_ctrl == 'newwin'
                split
            endif
            exe "edit " . escape(a:filename, ' ')
        else
            " Open a new window
            if g:Tlist_Use_Horiz_Window
                exe 'leftabove split ' . escape(a:filename, ' ')
            else
                if winbufnr(2) == -1
                    " Only the taglist window is present
                    if g:Tlist_Use_Right_Window
                        exe 'leftabove vertical split ' .
                                    \ escape(a:filename, ' ')
                    else
                        exe 'rightbelow vertical split ' .
                                    \ escape(a:filename, ' ')
                    endif

                    " Go to the taglist window to change the window size to
                    " the user configured value
                    call s:Tlist_Exe_Cmd_No_Acmds('wincmd p')
                    if g:Tlist_Use_Horiz_Window
                        exe 'resize ' . g:Tlist_WinHeight
                    else
                        exe 'vertical resize ' . g:Tlist_WinWidth
                    endif
                    " Go back to the file window
                    call s:Tlist_Exe_Cmd_No_Acmds('wincmd p')
                else
                    " A plugin or help window is also present
                    wincmd w
                    exe 'leftabove split ' . escape(a:filename, ' ')
                endif
            endif
        endif
        " Mark the window, so that it can be reused.
        call s:Tlist_Window_Mark_File_Window()
    else
        if v:version >= 700
            " If the file is opened in more than one window, then check
            " whether the last accessed window has the selected file.
            " If it does, then use that window.
            let lastwin_bufnum = winbufnr(winnr('#'))
            if bufnr(a:filename) == lastwin_bufnum
                let winnum = winnr('#')
            endif
        endif
        exe winnum . 'wincmd w'

        " If the user asked to jump to the tag in a new window, then split the
        " existing window into two.
        if a:win_ctrl == 'newwin'
            split
        endif
    endif
    endif

    " Jump to the tag
    if a:tagpat != ''
        " Add the current cursor position to the jump list, so that user can
        " jump back using the ' and ` marks.
        mark '
        silent call search(a:tagpat, 'w')

        " Bring the line to the middle of the window
        normal! z.

        " If the line is inside a fold, open the fold
        if foldclosed('.') != -1
            .foldopen
        endif
    endif

    " If the user selects to preview the tag then jump back to the
    " taglist window
    if a:win_ctrl == 'preview'
        " Go back to the taglist window
        let winnum = bufwinnr(g:TagList_title)
        exe winnum . 'wincmd w'
    else
        " If the user has selected to close the taglist window, when a
        " tag is selected, close the taglist  window
        if g:Tlist_Close_On_Select
            call s:Tlist_Window_Goto_Window()
            close

            " Go back to the window displaying the selected file
            let wnum = bufwinnr(a:filename)
            if wnum != -1 && wnum != winnr()
                call s:Tlist_Exe_Cmd_No_Acmds(wnum . 'wincmd w')
            endif
        endif
    endif

    let s:Tlist_Skip_Refresh = prev_Tlist_Skip_Refresh
endfunction

" Tlist_Window_Jump_To_Tag()
" Jump to the location of the current tag
" win_ctrl == useopen - Reuse the existing file window
" win_ctrl == newwin - Open a new window
" win_ctrl == preview - Preview the tag
" win_ctrl == prevwin - Open in previous window
" win_ctrl == newtab - Open in new tab
function! s:Tlist_Window_Jump_To_Tag(win_ctrl)
    call s:Tlist_Log_Msg('Tlist_Window_Jump_To_Tag(' . a:win_ctrl . ')')
    " Do not process comment lines and empty lines
    let curline = getline('.')
    if curline =~ '^\s*$' || curline[0] == '"'
        return
    endif

    " If inside a closed fold, then use the first line of the fold
    " and jump to the file.
    let lnum = foldclosed('.')
    if lnum == -1
        " Jump to the selected tag or file
        let lnum = line('.')
    else
        " Open the closed fold
        .foldopen!
    endif

    let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(lnum)
    if fidx == -1
        return
    endif

    " Get the tag output for the current tag
    let tidx = s:Tlist_Window_Get_Tag_Index(fidx, lnum)
    if tidx != 0
        let tagpat = s:Tlist_Get_Tag_SearchPat(fidx, tidx)

        " Highlight the tagline
        call s:Tlist_Window_Highlight_Line()
    else
        " Selected a line which is not a tag name. Just edit the file
        let tagpat = ''
    endif

    call s:Tlist_Window_Open_File(a:win_ctrl, s:tlist_{fidx}_filename, tagpat)
endfunction

" Tlist_Window_Show_Info()
" Display information about the entry under the cursor
function! s:Tlist_Window_Show_Info()
    call s:Tlist_Log_Msg('Tlist_Window_Show_Info()')

    " Clear the previously displayed line
    echo

    " Do not process comment lines and empty lines
    let curline = getline('.')
    if curline =~ '^\s*$' || curline[0] == '"'
        return
    endif

    " If inside a fold, then don't display the prototype
    if foldclosed('.') != -1
        return
    endif

    let lnum = line('.')

    " Get the file index
    let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(lnum)
    if fidx == -1
        return
    endif

    if lnum == s:tlist_{fidx}_start
        " Cursor is on a file name
        let fname = s:tlist_{fidx}_filename
        if strlen(fname) > 50
            let fname = fnamemodify(fname, ':t')
        endif
        echo fname . ', Filetype=' . s:tlist_{fidx}_filetype .
                    \  ', Tag count=' . s:tlist_{fidx}_tag_count
        return
    endif

    " Get the tag output line for the current tag
    let tidx = s:Tlist_Window_Get_Tag_Index(fidx, lnum)
    if tidx == 0
        " Cursor is on a tag type
        let ttype = s:Tlist_Window_Get_Tag_Type_By_Linenum(fidx, lnum)
        if ttype == ''
            return
        endif

        let ttype_name = ''

        let ftype = s:tlist_{fidx}_filetype
        let i = 1
        while i <= s:tlist_{ftype}_count
            if ttype == s:tlist_{ftype}_{i}_name
                let ttype_name = s:tlist_{ftype}_{i}_fullname
                break
            endif
            let i = i + 1
        endwhile

        echo 'Tag type=' . ttype_name .
                    \ ', Tag count=' . s:tlist_{fidx}_{ttype}_count
        return
    endif

    " Get the tag search pattern and display it
    echo s:Tlist_Get_Tag_Prototype(fidx, tidx)
endfunction

" Tlist_Find_Nearest_Tag_Idx
" Find the tag idx nearest to the supplied line number
" Returns -1, if a tag couldn't be found for the specified line number
function! s:Tlist_Find_Nearest_Tag_Idx(fidx, linenum)
    let sort_type = s:tlist_{a:fidx}_sort_type

    let left = 1
    let right = s:tlist_{a:fidx}_tag_count

    if sort_type == 'order'
        " Tags sorted by order, use a binary search.
        " The idea behind this function is taken from the ctags.vim script (by
        " Alexey Marinichev) available at the Vim online website.

        " If the current line is the less than the first tag, then no need to
        " search
        let first_lnum = s:Tlist_Get_Tag_Linenum(a:fidx, 1)

        if a:linenum < first_lnum
            return -1
        endif

        while left < right
            let middle = (right + left + 1) / 2
            let middle_lnum = s:Tlist_Get_Tag_Linenum(a:fidx, middle)

            if middle_lnum == a:linenum
                let left = middle
                break
            endif

            if middle_lnum > a:linenum
                let right = middle - 1
            else
                let left = middle
            endif
        endwhile
    else
        " Tags sorted by name, use a linear search. (contributed by Dave
        " Eggum).
        " Look for a tag with a line number less than or equal to the supplied
        " line number. If multiple tags are found, then use the tag with the
        " line number closest to the supplied line number. IOW, use the tag
        " with the highest line number.
        let closest_lnum = 0
        let final_left = 0
        while left <= right
            let lnum = s:Tlist_Get_Tag_Linenum(a:fidx, left)

            if lnum < a:linenum && lnum > closest_lnum
                let closest_lnum = lnum
                let final_left = left
            elseif lnum == a:linenum
                let closest_lnum = lnum
                let final_left = left
                break
            else
                let left = left + 1
            endif
        endwhile
        if closest_lnum == 0
            return -1
        endif
        if left >= right
            let left = final_left
        endif
    endif

    return left
endfunction

" Tlist_Window_Highlight_Tag()
" Highlight the current tag
" cntx == 1, Called by the taglist plugin itself
" cntx == 2, Forced by the user through the TlistHighlightTag command
" center = 1, move the tag line to the center of the taglist window
function! s:Tlist_Window_Highlight_Tag(filename, cur_lnum, cntx, center)
    " Highlight the current tag only if the user configured the
    " taglist plugin to do so or if the user explictly invoked the
    " command to highlight the current tag.
    if !g:Tlist_Auto_Highlight_Tag && a:cntx == 1
        return
    endif

    if a:filename == ''
        return
    endif

    " Make sure the taglist window is present
    let winnum = bufwinnr(g:TagList_title)
    if winnum == -1
        call s:Tlist_Warning_Msg('Error: Taglist window is not open')
        return
    endif

    let fidx = s:Tlist_Get_File_Index(a:filename)
    if fidx == -1
        return
    endif

    " If the file is currently not displayed in the taglist window, then retrn
    if !s:tlist_{fidx}_visible
        return
    endif

    " If there are no tags for this file, then no need to proceed further
    if s:tlist_{fidx}_tag_count == 0
        return
    endif

    " Ignore all autocommands
    let old_ei = &eventignore
    set eventignore=all

    " Save the original window number
    let org_winnr = winnr()

    if org_winnr == winnum
        let in_taglist_window = 1
    else
        let in_taglist_window = 0
    endif

    " Go to the taglist window
    if !in_taglist_window
        exe winnum . 'wincmd w'
    endif

    " Clear previously selected name
    match none

    let tidx = s:Tlist_Find_Nearest_Tag_Idx(fidx, a:cur_lnum)
    if tidx == -1
        " Make sure the current tag line is visible in the taglist window.
        " Calling the winline() function makes the line visible.  Don't know
        " of a better way to achieve this.
        let lnum = line('.')

        if lnum < s:tlist_{fidx}_start || lnum > s:tlist_{fidx}_end
            " Move the cursor to the beginning of the file
            exe s:tlist_{fidx}_start
        endif

        if foldclosed('.') != -1
            .foldopen
        endif

        call winline()

        if !in_taglist_window
            exe org_winnr . 'wincmd w'
        endif

        " Restore the autocommands
        let &eventignore = old_ei
        return
    endif

    " Extract the tag type
    let ttype = s:Tlist_Get_Tag_Type_By_Tag(fidx, tidx)

    " Compute the line number
    " Start of file + Start of tag type + offset
    let lnum = s:tlist_{fidx}_start + s:tlist_{fidx}_{ttype}_offset +
                \ s:tlist_{fidx}_{tidx}_ttype_idx

    " Goto the line containing the tag
    exe lnum

    " Open the fold
    if foldclosed('.') != -1
        .foldopen
    endif

    if a:center
        " Move the tag line to the center of the taglist window
        normal! z.
    else
        " Make sure the current tag line is visible in the taglist window.
        " Calling the winline() function makes the line visible.  Don't know
        " of a better way to achieve this.
        call winline()
    endif

    " Highlight the tag name
    call s:Tlist_Window_Highlight_Line()

    " Go back to the original window
    if !in_taglist_window
        exe org_winnr . 'wincmd w'
    endif

    " Restore the autocommands
    let &eventignore = old_ei
    return
endfunction

" Tlist_Get_Tag_Prototype_By_Line
" Get the prototype for the tag on or before the specified line number in the
" current buffer
function! Tlist_Get_Tag_Prototype_By_Line(...)
    if a:0 == 0
        " Arguments are not supplied. Use the current buffer name
        " and line number
        let filename = bufname('%')
        let linenr = line('.')
    elseif a:0 == 2
        " Filename and line number are specified
        let filename = a:1
        let linenr = a:2
        if linenr !~ '\d\+'
            " Invalid line number
            return ""
        endif
    else
        " Sufficient arguments are not supplied
        let msg =  'Usage: Tlist_Get_Tag_Prototype_By_Line <filename> ' .
                                \ '<line_number>'
        call s:Tlist_Warning_Msg(msg)
        return ""
    endif

    " Expand the file to a fully qualified name
    let filename = fnamemodify(filename, ':p')
    if filename == ''
        return ""
    endif

    let fidx = s:Tlist_Get_File_Index(filename)
    if fidx == -1
        return ""
    endif

    " If there are no tags for this file, then no need to proceed further
    if s:tlist_{fidx}_tag_count == 0
        return ""
    endif

    " Get the tag text using the line number
    let tidx = s:Tlist_Find_Nearest_Tag_Idx(fidx, linenr)
    if tidx == -1
        return ""
    endif

    return s:Tlist_Get_Tag_Prototype(fidx, tidx)
endfunction

" Tlist_Get_Tagname_By_Line
" Get the tag name on or before the specified line number in the
" current buffer
function! Tlist_Get_Tagname_By_Line(...)
    if a:0 == 0
        " Arguments are not supplied. Use the current buffer name
        " and line number
        let filename = bufname('%')
        let linenr = line('.')
    elseif a:0 == 2
        " Filename and line number are specified
        let filename = a:1
        let linenr = a:2
        if linenr !~ '\d\+'
            " Invalid line number
            return ""
        endif
    else
        " Sufficient arguments are not supplied
        let msg =  'Usage: Tlist_Get_Tagname_By_Line <filename> <line_number>'
        call s:Tlist_Warning_Msg(msg)
        return ""
    endif

    " Make sure the current file has a name
    let filename = fnamemodify(filename, ':p')
    if filename == ''
        return ""
    endif

    let fidx = s:Tlist_Get_File_Index(filename)
    if fidx == -1
        return ""
    endif

    " If there are no tags for this file, then no need to proceed further
    if s:tlist_{fidx}_tag_count == 0
        return ""
    endif

    " Get the tag name using the line number
    let tidx = s:Tlist_Find_Nearest_Tag_Idx(fidx, linenr)
    if tidx == -1
        return ""
    endif

    return s:tlist_{fidx}_{tidx}_tag_name
endfunction

" Tlist_Window_Move_To_File
" Move the cursor to the beginning of the current file or the next file
" or the previous file in the taglist window
" dir == -1, move to start of current or previous function
" dir == 1, move to start of next function
function! s:Tlist_Window_Move_To_File(dir)
    if foldlevel('.') == 0
        " Cursor is on a non-folded line (it is not in any of the files)
        " Move it to a folded line
        if a:dir == -1
            normal! zk
        else
            " While moving down to the start of the next fold,
            " no need to do go to the start of the next file.
            normal! zj
            return
        endif
    endif

    let fidx = s:Tlist_Window_Get_File_Index_By_Linenum(line('.'))
    if fidx == -1
        return
    endif

    let cur_lnum = line('.')

    if a:dir == -1
        if cur_lnum > s:tlist_{fidx}_start
            " Move to the beginning of the current file
            exe s:tlist_{fidx}_start
            return
        endif

        if fidx != 0
            " Move to the beginning of the previous file
            let fidx = fidx - 1
        else
            " Cursor is at the first file, wrap around to the last file
            let fidx = s:tlist_file_count - 1
        endif

        exe s:tlist_{fidx}_start
        return
    else
        " Move to the beginning of the next file
        let fidx = fidx + 1

        if fidx >= s:tlist_file_count
            " Cursor is at the last file, wrap around to the first file
            let fidx = 0
        endif

        if s:tlist_{fidx}_start != 0
            exe s:tlist_{fidx}_start
        endif
        return
    endif
endfunction

" Tlist_Session_Load
" Load a taglist session (information about all the displayed files
" and the tags) from the specified file
function! s:Tlist_Session_Load(...)
    if a:0 == 0 || a:1 == ''
        call s:Tlist_Warning_Msg('Usage: TlistSessionLoad <filename>')
        return
    endif

    let sessionfile = a:1

    if !filereadable(sessionfile)
        let msg = 'Taglist: Error - Unable to open file ' . sessionfile
        call s:Tlist_Warning_Msg(msg)
        return
    endif

    " Mark the current window as the file window
    call s:Tlist_Window_Mark_File_Window()

    " Source the session file
    exe 'source ' . sessionfile

    let new_file_count = g:tlist_file_count
    unlet! g:tlist_file_count

    let i = 0
    while i < new_file_count
        let ftype = g:tlist_{i}_filetype
        unlet! g:tlist_{i}_filetype

        if !exists('s:tlist_' . ftype . '_count')
            if s:Tlist_FileType_Init(ftype) == 0
                let i = i + 1
                continue
            endif
        endif

        let fname = g:tlist_{i}_filename
        unlet! g:tlist_{i}_filename

        let fidx = s:Tlist_Get_File_Index(fname)
        if fidx != -1
            let s:tlist_{fidx}_visible = 0
            let i = i + 1
            continue
        else
            " As we are loading the tags from the session file, if this
            " file was previously deleted by the user, now we need to
            " add it back. So remove the file from the deleted list.
            call s:Tlist_Update_Remove_List(fname, 0)
        endif

        let fidx = s:Tlist_Init_File(fname, ftype)

        let s:tlist_{fidx}_filename = fname

        let s:tlist_{fidx}_sort_type = g:tlist_{i}_sort_type
        unlet! g:tlist_{i}_sort_type

        let s:tlist_{fidx}_filetype = ftype
        let s:tlist_{fidx}_mtime = getftime(fname)

        let s:tlist_{fidx}_start = 0
        let s:tlist_{fidx}_end = 0

        let s:tlist_{fidx}_valid = 1

        let s:tlist_{fidx}_tag_count = g:tlist_{i}_tag_count
        unlet! g:tlist_{i}_tag_count

        let j = 1
        while j <= s:tlist_{fidx}_tag_count
            let s:tlist_{fidx}_{j}_tag = g:tlist_{i}_{j}_tag
            let s:tlist_{fidx}_{j}_tag_name = g:tlist_{i}_{j}_tag_name
            let s:tlist_{fidx}_{j}_ttype_idx = g:tlist_{i}_{j}_ttype_idx
            unlet! g:tlist_{i}_{j}_tag
            unlet! g:tlist_{i}_{j}_tag_name
            unlet! g:tlist_{i}_{j}_ttype_idx
            let j = j + 1
        endwhile

        let j = 1
        while j <= s:tlist_{ftype}_count
            let ttype = s:tlist_{ftype}_{j}_name

            if exists('g:tlist_' . i . '_' . ttype)
                let s:tlist_{fidx}_{ttype} = g:tlist_{i}_{ttype}
                unlet! g:tlist_{i}_{ttype}
                let s:tlist_{fidx}_{ttype}_offset = 0
                let s:tlist_{fidx}_{ttype}_count = g:tlist_{i}_{ttype}_count
                unlet! g:tlist_{i}_{ttype}_count

                let k = 1
                while k <= s:tlist_{fidx}_{ttype}_count
                    let s:tlist_{fidx}_{ttype}_{k} = g:tlist_{i}_{ttype}_{k}
                    unlet! g:tlist_{i}_{ttype}_{k}
                    let k = k + 1
                endwhile
            else
                let s:tlist_{fidx}_{ttype} = ''
                let s:tlist_{fidx}_{ttype}_offset = 0
                let s:tlist_{fidx}_{ttype}_count = 0
            endif

            let j = j + 1
        endwhile

        let i = i + 1
    endwhile

    " If the taglist window is open, then update it
    let winnum = bufwinnr(g:TagList_title)
    if winnum != -1
        let save_winnr = winnr()

        " Goto the taglist window
        call s:Tlist_Window_Goto_Window()

        " Refresh the taglist window
        call s:Tlist_Window_Refresh()

        " Go back to the original window
        if save_winnr != winnr()
            call s:Tlist_Exe_Cmd_No_Acmds('wincmd p')
        endif
    endif
endfunction

" Tlist_Session_Save
" Save a taglist session (information about all the displayed files
" and the tags) into the specified file
function! s:Tlist_Session_Save(...)
    if a:0 == 0 || a:1 == ''
        call s:Tlist_Warning_Msg('Usage: TlistSessionSave <filename>')
        return
    endif

    let sessionfile = a:1

    if s:tlist_file_count == 0
        " There is nothing to save
        call s:Tlist_Warning_Msg('Warning: Taglist is empty. Nothing to save.')
        return
    endif

    if filereadable(sessionfile)
        let ans = input('Do you want to overwrite ' . sessionfile . ' (Y/N)?')
        if ans !=? 'y'
            return
        endif

        echo "\n"
    endif

    let old_verbose = &verbose
    set verbose&vim

    exe 'redir! > ' . sessionfile

    silent! echo '" Taglist session file. This file is auto-generated.'
    silent! echo '" File information'
    silent! echo 'let tlist_file_count = ' . s:tlist_file_count

    let i = 0

    while i < s:tlist_file_count
        " Store information about the file
        silent! echo 'let tlist_' . i . "_filename = '" .
                                            \ s:tlist_{i}_filename . "'"
        silent! echo 'let tlist_' . i . '_sort_type = "' .
                                                \ s:tlist_{i}_sort_type . '"'
        silent! echo 'let tlist_' . i . '_filetype = "' .
                                            \ s:tlist_{i}_filetype . '"'
        silent! echo 'let tlist_' . i . '_tag_count = ' .
                                                        \ s:tlist_{i}_tag_count
        " Store information about all the tags
        let j = 1
        while j <= s:tlist_{i}_tag_count
            let txt = escape(s:tlist_{i}_{j}_tag, '"\\')
            silent! echo 'let tlist_' . i . '_' . j . '_tag = "' . txt . '"'
            silent! echo 'let tlist_' . i . '_' . j . '_tag_name = "' .
                        \ s:tlist_{i}_{j}_tag_name . '"'
            silent! echo 'let tlist_' . i . '_' . j . '_ttype_idx' . ' = ' .
                        \ s:tlist_{i}_{j}_ttype_idx
            let j = j + 1
        endwhile

        " Store information about all the tags grouped by their type
        let ftype = s:tlist_{i}_filetype
        let j = 1
        while j <= s:tlist_{ftype}_count
            let ttype = s:tlist_{ftype}_{j}_name
            if s:tlist_{i}_{ttype}_count != 0
                let txt = escape(s:tlist_{i}_{ttype}, '"\')
                let txt = substitute(txt, "\n", "\\\\n", 'g')
                silent! echo 'let tlist_' . i . '_' . ttype . ' = "' .
                                                \ txt . '"'
                silent! echo 'let tlist_' . i . '_' . ttype . '_count = ' .
                                                     \ s:tlist_{i}_{ttype}_count
                let k = 1
                while k <= s:tlist_{i}_{ttype}_count
                    silent! echo 'let tlist_' . i . '_' . ttype . '_' . k .
                                \ ' = ' . s:tlist_{i}_{ttype}_{k}
                    let k = k + 1
                endwhile
            endif
            let j = j + 1
        endwhile

        silent! echo

        let i = i + 1
    endwhile

    redir END

    let &verbose = old_verbose
endfunction

" Tlist_Buffer_Removed
" A buffer is removed from the Vim buffer list. Remove the tags defined
" for that file
function! s:Tlist_Buffer_Removed(filename)
    call s:Tlist_Log_Msg('Tlist_Buffer_Removed (' . a:filename .  ')')

    " Make sure a valid filename is supplied
    if a:filename == ''
        return
    endif

    " Get tag list index of the specified file
    let fidx = s:Tlist_Get_File_Index(a:filename)
    if fidx == -1
        " File not present in the taglist
        return
    endif

    " Remove the file from the list
    call s:Tlist_Remove_File(fidx, 0)
endfunction

" When a buffer is deleted, remove the file from the taglist
autocmd BufDelete * silent call s:Tlist_Buffer_Removed(expand('<afile>:p'))

" Tlist_Window_Open_File_Fold
" Open the fold for the specified file and close the fold for all the
" other files
function! s:Tlist_Window_Open_File_Fold(acmd_bufnr)
    call s:Tlist_Log_Msg('Tlist_Window_Open_File_Fold (' . a:acmd_bufnr . ')')

    " Make sure the taglist window is present
    let winnum = bufwinnr(g:TagList_title)
    if winnum == -1
        call s:Tlist_Warning_Msg('Taglist: Error - Taglist window is not open')
        return
    endif

    " Save the original window number
    let org_winnr = winnr()
    if org_winnr == winnum
        let in_taglist_window = 1
    else
        let in_taglist_window = 0
    endif

    if in_taglist_window
        " When entering the taglist window, no need to update the folds
        return
    endif

    " Go to the taglist window
    if !in_taglist_window
        call s:Tlist_Exe_Cmd_No_Acmds(winnum . 'wincmd w')
    endif

    " Close all the folds
    silent! %foldclose

    " Get tag list index of the specified file
    let fname = fnamemodify(bufname(a:acmd_bufnr + 0), ':p')
    if filereadable(fname)
        let fidx = s:Tlist_Get_File_Index(fname)
        if fidx != -1
            " Open the fold for the file
            exe "silent! " . s:tlist_{fidx}_start . "," .
                        \ s:tlist_{fidx}_end . "foldopen"
        endif
    endif

    " Go back to the original window
    if !in_taglist_window
        call s:Tlist_Exe_Cmd_No_Acmds(org_winnr . 'wincmd w')
    endif
endfunction

" Tlist_Window_Check_Auto_Open
" Open the taglist window automatically on Vim startup.
" Open the window only when files present in any of the Vim windows support
" tags.
function! s:Tlist_Window_Check_Auto_Open()
    let open_window = 0

    let i = 1
    let buf_num = winbufnr(i)
    while buf_num != -1
        let filename = fnamemodify(bufname(buf_num), ':p')
        let ft = s:Tlist_Get_Buffer_Filetype(buf_num)
        if !s:Tlist_Skip_File(filename, ft)
            let open_window = 1
            break
        endif
        let i = i + 1
        let buf_num = winbufnr(i)
    endwhile

    if open_window
        call s:Tlist_Window_Toggle()
    endif
endfunction

" Tlist_Refresh_Folds
" Remove and create the folds for all the files displayed in the taglist
" window. Used after entering a tab. If this is not done, then the folds
" are not properly created for taglist windows displayed in multiple tabs.
function! s:Tlist_Refresh_Folds()
    let winnum = bufwinnr(g:TagList_title)
    if winnum == -1
        return
    endif

    let save_wnum = winnr()
    exe winnum . 'wincmd w'

    " First remove all the existing folds
    normal! zE

    " Create the folds for each in the tag list
    let fidx = 0
    while fidx < s:tlist_file_count
        let ftype = s:tlist_{fidx}_filetype

        " Create the folds for each tag type in a file
        let j = 1
        while j <= s:tlist_{ftype}_count
            let ttype = s:tlist_{ftype}_{j}_name
            if s:tlist_{fidx}_{ttype}_count
                let s = s:tlist_{fidx}_start + s:tlist_{fidx}_{ttype}_offset
                let e = s + s:tlist_{fidx}_{ttype}_count
                exe s . ',' . e . 'fold'
            endif
            let j = j + 1
        endwhile

        exe s:tlist_{fidx}_start . ',' . s:tlist_{fidx}_end . 'fold'
        exe 'silent! ' . s:tlist_{fidx}_start . ',' .
                    \ s:tlist_{fidx}_end . 'foldopen!'
        let fidx = fidx + 1
    endwhile

    exe save_wnum . 'wincmd w'
endfunction

function! s:Tlist_Menu_Add_Base_Menu()
    call s:Tlist_Log_Msg('Adding the base menu')

    " Add the menu
    anoremenu <silent> T&ags.Refresh\ menu :call <SID>Tlist_Menu_Refresh()<CR>
    anoremenu <silent> T&ags.Sort\ menu\ by.Name
                    \ :call <SID>Tlist_Change_Sort('menu', 'set', 'name')<CR>
    anoremenu <silent> T&ags.Sort\ menu\ by.Order
                    \ :call <SID>Tlist_Change_Sort('menu', 'set', 'order')<CR>
    anoremenu T&ags.-SEP1-           :

    if &mousemodel =~ 'popup'
        anoremenu <silent> PopUp.T&ags.Refresh\ menu
                    \ :call <SID>Tlist_Menu_Refresh()<CR>
        anoremenu <silent> PopUp.T&ags.Sort\ menu\ by.Name
                  \ :call <SID>Tlist_Change_Sort('menu', 'set', 'name')<CR>
        anoremenu <silent> PopUp.T&ags.Sort\ menu\ by.Order
                  \ :call <SID>Tlist_Change_Sort('menu', 'set', 'order')<CR>
        anoremenu PopUp.T&ags.-SEP1-           :
    endif
endfunction

let s:menu_char_prefix =
            \ '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

" Tlist_Menu_Get_Tag_Type_Cmd
" Get the menu command for the specified tag type
" fidx - File type index
" ftype - File Type
" add_ttype_name - To add or not to add the tag type name to the menu entries
" ttype_idx - Tag type index
function! s:Tlist_Menu_Get_Tag_Type_Cmd(fidx, ftype, add_ttype_name, ttype_idx)
    " Curly brace variable name optimization
    let ftype_ttype_idx = a:ftype . '_' . a:ttype_idx

    let ttype = s:tlist_{ftype_ttype_idx}_name
    if a:add_ttype_name
        " If the tag type name contains space characters, escape it. This
        " will be used to create the menu entries.
        let ttype_fullname = escape(s:tlist_{ftype_ttype_idx}_fullname, ' ')
    endif

    " Curly brace variable name optimization
    let fidx_ttype = a:fidx . '_' . ttype

    " Number of tag entries for this tag type
    let tcnt = s:tlist_{fidx_ttype}_count
    if tcnt == 0 " No entries for this tag type
        return ''
    endif

    let mcmd = ''

    " Create the menu items for the tags.
    " Depending on the number of tags of this type, split the menu into
    " multiple sub-menus, if needed.
    if tcnt > g:Tlist_Max_Submenu_Items
        let j = 1
        while j <= tcnt
            let final_index = j + g:Tlist_Max_Submenu_Items - 1
            if final_index > tcnt
                let final_index = tcnt
            endif

            " Extract the first and last tag name and form the
            " sub-menu name
            let tidx = s:tlist_{fidx_ttype}_{j}
            let first_tag = s:tlist_{a:fidx}_{tidx}_tag_name

            let tidx = s:tlist_{fidx_ttype}_{final_index}
            let last_tag = s:tlist_{a:fidx}_{tidx}_tag_name

            " Truncate the names, if they are greater than the
            " max length
            let first_tag = strpart(first_tag, 0, g:Tlist_Max_Tag_Length)
            let last_tag = strpart(last_tag, 0, g:Tlist_Max_Tag_Length)

            " Form the menu command prefix
            let m_prefix = 'anoremenu <silent> T\&ags.'
            if a:add_ttype_name
                let m_prefix = m_prefix . ttype_fullname . '.'
            endif
            let m_prefix = m_prefix . first_tag . '\.\.\.' . last_tag . '.'

            " Character prefix used to number the menu items (hotkey)
            let m_prefix_idx = 0

            while j <= final_index
                let tidx = s:tlist_{fidx_ttype}_{j}

                let tname = s:tlist_{a:fidx}_{tidx}_tag_name

                let mcmd = mcmd . m_prefix . '\&' .
                            \ s:menu_char_prefix[m_prefix_idx] . '\.' .
                            \ tname . ' :call <SID>Tlist_Menu_Jump_To_Tag(' .
                            \ tidx . ')<CR>|'

                let m_prefix_idx = m_prefix_idx + 1
                let j = j + 1
            endwhile
        endwhile
    else
        " Character prefix used to number the menu items (hotkey)
        let m_prefix_idx = 0

        let m_prefix = 'anoremenu <silent> T\&ags.'
        if a:add_ttype_name
            let m_prefix = m_prefix . ttype_fullname . '.'
        endif
        let j = 1
        while j <= tcnt
            let tidx = s:tlist_{fidx_ttype}_{j}

            let tname = s:tlist_{a:fidx}_{tidx}_tag_name

            let mcmd = mcmd . m_prefix . '\&' .
                        \ s:menu_char_prefix[m_prefix_idx] . '\.' .
                        \ tname . ' :call <SID>Tlist_Menu_Jump_To_Tag(' . tidx
                        \ . ')<CR>|'

            let m_prefix_idx = m_prefix_idx + 1
            let j = j + 1
        endwhile
    endif

    return mcmd
endfunction

" Update the taglist menu with the tags for the specified file
function! s:Tlist_Menu_File_Refresh(fidx)
    call s:Tlist_Log_Msg('Refreshing the tag menu for ' . s:tlist_{a:fidx}_filename)
    " The 'B' flag is needed in the 'cpoptions' option
    let old_cpoptions = &cpoptions
    set cpoptions&vim

    exe s:tlist_{a:fidx}_menu_cmd

    " Update the popup menu (if enabled)
    if &mousemodel =~ 'popup'
        let cmd = substitute(s:tlist_{a:fidx}_menu_cmd, ' T\\&ags\.',
                                        \ ' PopUp.T\\\&ags.', "g")
        exe cmd
    endif

    " The taglist menu is not empty now
    let s:tlist_menu_empty = 0

    " Restore the 'cpoptions' settings
    let &cpoptions = old_cpoptions
endfunction

" Tlist_Menu_Update_File
" Add the taglist menu
function! s:Tlist_Menu_Update_File(clear_menu)
    if !has('gui_running')
        " Not running in GUI mode
        return
    endif

    call s:Tlist_Log_Msg('Updating the tag menu, clear_menu = ' . a:clear_menu)

    " Remove the tags menu
    if a:clear_menu
        call s:Tlist_Menu_Remove_File()

    endif

    " Skip buffers with 'buftype' set to nofile, nowrite, quickfix or help
    if &buftype != ''
        return
    endif

    let filename = fnamemodify(bufname('%'), ':p')
    let ftype = s:Tlist_Get_Buffer_Filetype('%')

    " If the file doesn't support tag listing, skip it
    if s:Tlist_Skip_File(filename, ftype)
        return
    endif

    let fidx = s:Tlist_Get_File_Index(filename)
    if fidx == -1 || !s:tlist_{fidx}_valid
        " Check whether this file is removed based on user request
        " If it is, then don't display the tags for this file
        if s:Tlist_User_Removed_File(filename)
            return
        endif

        " Process the tags for the file
        let fidx = s:Tlist_Process_File(filename, ftype)
        if fidx == -1
            return
        endif
    endif

    let fname = escape(fnamemodify(bufname('%'), ':t'), '.')
    if fname != ''
        exe 'anoremenu T&ags.' .  fname . ' <Nop>'
        anoremenu T&ags.-SEP2-           :
    endif

    if !s:tlist_{fidx}_tag_count
        return
    endif

    if s:tlist_{fidx}_menu_cmd != ''
        " Update the menu with the cached command
        call s:Tlist_Menu_File_Refresh(fidx)

        return
    endif

    " We are going to add entries to the tags menu, so the menu won't be
    " empty
    let s:tlist_menu_empty = 0

    let cmd = ''

    " Determine whether the tag type name needs to be added to the menu
    " If more than one tag type is present in the taglisting for a file,
    " then the tag type name needs to be present
    let add_ttype_name = -1
    let i = 1
    while i <= s:tlist_{ftype}_count && add_ttype_name < 1
        let ttype = s:tlist_{ftype}_{i}_name
        if s:tlist_{fidx}_{ttype}_count
            let add_ttype_name = add_ttype_name + 1
        endif
        let i = i + 1
    endwhile

    " Process the tags by the tag type and get the menu command
    let i = 1
    while i <= s:tlist_{ftype}_count
        let mcmd = s:Tlist_Menu_Get_Tag_Type_Cmd(fidx, ftype, add_ttype_name, i)
        if mcmd != ''
            let cmd = cmd . mcmd
        endif

        let i = i + 1
    endwhile

    " Cache the menu command for reuse
    let s:tlist_{fidx}_menu_cmd = cmd

    " Update the menu
    call s:Tlist_Menu_File_Refresh(fidx)
endfunction

" Tlist_Menu_Remove_File
" Remove the tags displayed in the tags menu
function! s:Tlist_Menu_Remove_File()
    if !has('gui_running') || s:tlist_menu_empty
        return
    endif

    call s:Tlist_Log_Msg('Removing the tags menu for a file')

    " Cleanup the Tags menu
    silent! unmenu T&ags
    if &mousemodel =~ 'popup'
        silent! unmenu PopUp.T&ags
    endif

    " Add a dummy menu item to retain teared off menu
    noremenu T&ags.Dummy l

    silent! unmenu! T&ags
    if &mousemodel =~ 'popup'
        silent! unmenu! PopUp.T&ags
    endif

    call s:Tlist_Menu_Add_Base_Menu()

    " Remove the dummy menu item
    unmenu T&ags.Dummy

    let s:tlist_menu_empty = 1
endfunction

" Tlist_Menu_Refresh
" Refresh the taglist menu
function! s:Tlist_Menu_Refresh()
    call s:Tlist_Log_Msg('Refreshing the tags menu')
    let fidx = s:Tlist_Get_File_Index(fnamemodify(bufname('%'), ':p'))
    if fidx != -1
        " Invalidate the cached menu command
        let s:tlist_{fidx}_menu_cmd = ''
    endif

    " Update the taglist, menu and window
    call s:Tlist_Update_Current_File()
endfunction

" Tlist_Menu_Jump_To_Tag
" Jump to the selected tag
function! s:Tlist_Menu_Jump_To_Tag(tidx)
    let fidx = s:Tlist_Get_File_Index(fnamemodify(bufname('%'), ':p'))
    if fidx == -1
        return
    endif

    let tagpat = s:Tlist_Get_Tag_SearchPat(fidx, a:tidx)
    if tagpat == ''
        return
    endif

    " Add the current cursor position to the jump list, so that user can
    " jump back using the ' and ` marks.
    mark '

    silent call search(tagpat, 'w')

    " Bring the line to the middle of the window
    normal! z.

    " If the line is inside a fold, open the fold
    if foldclosed('.') != -1
        .foldopen
    endif
endfunction

" Tlist_Menu_Init
" Initialize the taglist menu
function! s:Tlist_Menu_Init()
    call s:Tlist_Menu_Add_Base_Menu()

    " Automatically add the tags defined in the current file to the menu
    augroup TagListMenuCmds
        autocmd!

        if !g:Tlist_Process_File_Always
            autocmd BufEnter * call s:Tlist_Refresh()
        endif
        autocmd BufLeave * call s:Tlist_Menu_Remove_File()
    augroup end

    call s:Tlist_Menu_Update_File(0)
endfunction

" Tlist_Vim_Session_Load
" Initialize the taglist window/buffer, which is created when loading
" a Vim session file.
function! s:Tlist_Vim_Session_Load()
    call s:Tlist_Log_Msg('Tlist_Vim_Session_Load')

    " Initialize the taglist window
    call s:Tlist_Window_Init()

    " Refresh the taglist window
    call s:Tlist_Window_Refresh()
endfunction

" Tlist_Set_App
" Set the name of the external plugin/application to which taglist
" belongs.
" Taglist plugin is part of another plugin like cream or winmanager.
function! Tlist_Set_App(name)
    if a:name == ""
        return
    endif

    let s:tlist_app_name = a:name
endfunction

" Winmanager integration

" Initialization required for integration with winmanager
function! TagList_Start()
    " If current buffer is not taglist buffer, then don't proceed
    if bufname('%') != '__Tag_List__'
        return
    endif

    call Tlist_Set_App('winmanager')

    " Get the current filename from the winmanager plugin
    let bufnum = WinManagerGetLastEditedFile()
    if bufnum != -1
        let filename = fnamemodify(bufname(bufnum), ':p')
        let ftype = s:Tlist_Get_Buffer_Filetype(bufnum)
    endif

    " Initialize the taglist window, if it is not already initialized
    if !exists('s:tlist_window_initialized') || !s:tlist_window_initialized
        call s:Tlist_Window_Init()
        call s:Tlist_Window_Refresh()
        let s:tlist_window_initialized = 1
    endif

    " Update the taglist window
    if bufnum != -1
        if !s:Tlist_Skip_File(filename, ftype) && g:Tlist_Auto_Update
            call s:Tlist_Window_Refresh_File(filename, ftype)
        endif
    endif
endfunction

function! TagList_IsValid()
    return 0
endfunction

function! TagList_WrapUp()
    return 0
endfunction

" restore 'cpo'
let &cpo = s:cpo_save
