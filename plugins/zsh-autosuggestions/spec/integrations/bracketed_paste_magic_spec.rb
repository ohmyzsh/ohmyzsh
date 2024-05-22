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

  context 'with `bracketed-paste` added to the list of widgets that clear the suggestion' do
    let(:options) { ['ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)'] }

    it 'does not retain an old suggestion' do
      with_history ('echo foo') do
        session.send_string('echo ')
        wait_for { session.content }.to eq('echo foo')
        session.paste_string('bar')
        wait_for { session.content }.to eq('echo bar')
        session.send_keys('C-a') # Any cursor movement works
        sleep 1
        expect(session.content).to eq('echo bar')
      end
    end
  end
end
