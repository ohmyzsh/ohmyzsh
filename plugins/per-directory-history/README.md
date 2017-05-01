[Per-Directory-History][6]
=========================

Per directory history for zsh, as well as global history, and the
ability to toggle between them with ^G.

This is a implementation of per directory history for zsh, some 
implementations of which exist in bash[1][],[2][].  It also implements 
a per-directory-history-toggle-history function to change from using the 
directory history to using the global history.  In both cases the history is 
always saved to both the global history and the directory history, so the 
toggle state will not effect the saved histories.  Being able to switch 
between global and directory histories on the fly is a novel feature as far 
as I am aware.

This is a standalone repository for the script, however it is also included in
[oh-my-zsh][4] as a plugin.

----------------------------------------------------------------------------
Usage
----------------------------------------------------------------------------

1.  Load this script into your interactive ZSH session:

        % source zsh-per-directory-history.zsh

2.  The default mode if per directory history, interact with your history as normal.

3.  Press ^G (the Control and G keys simultaneously) to toggle between local
    and global histories.  If you would prefer a different shortcut to toggle
    set the PER_DIRECTORY_HISTORY_TOGGLE environment variable.

-------------------------------------------------------------------------------
Configuration
-------------------------------------------------------------------------------

* HISTORY_BASE a global variable that defines the base directory in which the 
  directory histories are stored
* per-directory-history-toggle-history is the function to toggle the history

-------------------------------------------------------------------------------
History
-------------------------------------------------------------------------------

The idea/inspiration for a per directory history is from [Stewart MacArthur][1] 
and [Dieter][2], the implementation idea is from [Bart Schaefer][3].  The 
implementation is by [Jim Hester][5] in September 2012.

[1]: http://www.compbiome.com/2010/07/bash-per-directory-bash-history.html
[2]: http://dieter.plaetinck.be/per_directory_bash
[3]: http://www.zsh.org/mla/users/1997/msg00226.html
[4]: https://github.com/robbyrussell/oh-my-zsh
[5]: http://jimhester.com
[6]: http://github.com/jimhester/per-directory-history

