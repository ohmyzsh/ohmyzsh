A simple aliasing scheme for the different kinds of systems
that have command line app installers.

On Mac systems, it's assumed the installer is brew
On Suse based sysetms, it's zypper
On Redhat, it's yum
On Debian/Ubuntu it's apt-get

include the installer as a plugin in your ~/.zshrc

to install a new app run
install <app>

you can upgrade an app with
upgrade <app>
