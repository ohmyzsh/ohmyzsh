record_session(){
    sudo apt-get install asciinema

    output_folder=assets
    filename=asciinema-recording.cast

    asciinema rec $output_folder/$filename
    sleep 2

    echo "Global pip packages..."
    pip list
    sleep 2

    temp_folder=temporary_folder
    mkdir $temp_folder
    cd $temp_folder
    sleep 2

    # Ask for its help
    viper-env help
    sleep 2

    # Create virutal environment
    python -m venv .venv
    sleep 2

    # Activate it
    . .venv/bin/activate
    sleep 2

    # Create direnv file
    export VIRTUAL_ENV=venv > .envrc
    sleep 2
    
    # Allow it
    direnv allow .
    sleep 2

    # Save current dir
    current_dir=$(basename $PWD)
    sleep 2

    # Exit current directory
    cd ..
    sleep 2

    # Reenter it
    cd $current_dir
    sleep 2

    echo "Virtualenv pip packages..."
    pip list
    python -m pip install upgrade pip
    sleep 2

    echo "Virtualenv pip packages with updated pip now..."
    pip list
    sleep 2

    exit
}