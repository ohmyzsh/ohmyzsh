describe 'pasting using bracketed-paste-magic' do
  let(:before_sourcing) do
    -> do
      session.
        run_command('autoload -Uz bracketed-paste-magic').
        run_command('zle -N bracketed-paste bracketed-paste-magic')
    end
  end

  context 'with suggestions disabled while pasting' do
    before do
      session.
        run_command('bpm_init() { zle autosuggest-disable }').
        run_command('bpm_finish() { zle autosuggest-enable }').
        run_command('zstyle :bracketed-paste-magic paste-init bpm_init').
        run_command('zstyle :bracketed-paste-magic paste-finish bpm_finish')
    end

    it 'does not show an incorrect suggestion' do
      with_history('echo hello') do
        session.paste_string("echo #{'a' * 60}")
        sleep 1
        expect(session.content).to eq("echo #{'a' * 60}")
      end
    end
  end
end
