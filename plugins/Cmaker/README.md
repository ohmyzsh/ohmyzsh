# Cmaker
An oh-my-zsh plugin to make using cmake easier.

## How It Works
Cmaker uses a template text file located in the ```~/.oh-my-zsh/custom/plugins/cMaker``` directory to create a CMakeLists.txt file which will act as a config file when commands like ```cgen```,```ccomp``` and ```cbin``` are run. You can use ```ctemp``` to edit the template file or you can use ```cgen``` and then edit the CMakeLists.txt file after it has been generated. However, this not possible with commands like ```ccomp``` and ```cbin``` as they instantly run the code after generating the cmake files. In that case, you mest edit the template. A basic template has already been setup for you.

## Commands
* ```cjump``` -> If you are in the directory of your project ```cjump``` will open the 'main' file in your project. No arguements for this commands
* ```clist``` -> ```clist``` will list every file ending with .cpp or .cc in your current directory.  No arguements for this commands
* ```cgen``` -> Creates the ```CMakeLists.txt``` file (with basic configs allowing you to run instantly) as well as the src directory along with main.cpp in the src. Usage : ```cgen <project name>``
* ```crun``` -> This will produce a binary file after you have used ```cgen``` and written in the main.cpp file. Use ```crun <directory name>```
* ```cbin``` -> This will instantly create a binary file called cpc. Pass filename as an arguement : ```cbin <file path>```
* ```cput``` -> Moves all files from one directory to another. Usage : ```cput <directory> <directory to move files to>```
* ```ccomp``` -> Runs a directory of cpp files containing main.cpp and which are part of one project. Usage : ```ccomp <dir name>```
* ```ctemp``` -> Allows you to edit the template with which CMakeLists.txt will be created. No arguements required

## Notes:
* cbuild | Make sure your project name doesnt conflict with other directory names.
* cbin | This only works with single files but is faster than ccomp.
* ccomp | Make sure that you don't have a directory called qwertyu in your current dir when you're running this.
* This plugin can only be used to generate templates for binary projects not library projects.

***Created by Aadi P***
