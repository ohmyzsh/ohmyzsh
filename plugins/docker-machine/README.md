# docker-machine plugin for oh my zsh

### Usage

#### docker-vm
Will create a docker-machine with the name "dev" (required only once)
To create a second machine call "docker-vm foobar" or pass any other name

#### docker-up
This will start your "dev" docker-machine (if necessary) and set it as the active one
To start a named machine use "docker-up foobar"

#### docker-switch dev
Use this to activate a running docker-machine (or to switch between multiple machines)
You need to call either this or docker-up when opening a new terminal

#### docker-stop
This will stop your "dev" docker-machine
To stop a named machine use "docker-stop foobar"