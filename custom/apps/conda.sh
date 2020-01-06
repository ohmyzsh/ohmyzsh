# Conda
# >>> conda initialize >>>
default_conda_env="/home/vavalm/anaconda3/envs/env_data_science"
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vavalm/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vavalm/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vavalm/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vavalm/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

conda activate env_data_science
# <<< conda initialize <<<
