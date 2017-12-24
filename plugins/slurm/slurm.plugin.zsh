
# slurm command completion
function _slurm_hosts() {
    _values `sinfo -o "%N" -h | tr ',' ' '`
}
compdef _slurm_hosts salloc
