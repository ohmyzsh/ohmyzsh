context 'with zle-line-init unignored' do
  let(:after_sourcing) do
    -> do
      session.
        run_command('setopt extendedglob').
        run_command('ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(${(@)ZSH_AUTOSUGGEST_IGNORE_WIDGETS:#zle-\*} zle-\^line-init)').
        run_command('zle-line-init() { BUFFER="echo" }')
    end
  end

  it 'should fetch a suggestion on each line initialization' do
    with_history('echo foo') do
      session.run_command('zle -N zle-line-init')
      wait_for { session.content }.to end_with('echo foo')
    end
  end
end
