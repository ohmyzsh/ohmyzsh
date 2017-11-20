This plugin was created because the aliases in the debian plugin are inconsistent and hard to remember. Also this apt-priority detection that switched between apt-get and aptitude was dropped to keep it simpler. This plugin uses apt-get for everything but a few things that are only possible with aptitude I guess. Ubuntu does not have aptitude installed by default.

acs = Apt-Cache Search  
acp = Apt-Cache Policy

ag  = sudo Apt-Get  
agi = sudo Apt-Get Install  
agd = sudo Apt-Get Dselect-upgrade  
By now you already can guess almost all aliases  

There are two exeptions since ...  
agu  = sudo Apt-Get Update  - we have ...  
agug = sudo Apt-Get UpGrade - as the exceptional 4 letter alias for a single command.

afs = Apt-File Search --regexp - this has the regexp switch on without being represented in the alias, I guess this makes sense since the debian plugin has it, I never used that command.

Then there are the 2 other 4 letter aliases for combined commands, that are straight forward and easy to remember.  
aguu = sudo Apt-Get Update && sudo apt-get Upgrade      - better then adg or not?  
agud = sudo Apt-Get Update && sudo apt-get full-upgrade

For a full list aliases and the functions just watch the plugins code https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/ubuntu/ubuntu.plugin.zsh, look at the comments if you want to switch from the debian plugin. Ubuntu, Mint and & co users will like the new aar function to install packages from ppas with a single command.
