context 'with asynchronous suggestions enabled' do
  let(:options) { ["ZSH_AUTOSUGGEST_USE_ASYNC="] }

  describe '`up-line-or-beginning-search`' do
    let(:before_sourcing) do
      -> do
        session.
          run_command('autoload -U up-line-or-beginning-search').
          run_command('zle -N up-line-or-beginning-search').
          send_string('bindkey "').
          send_keys('C-v').send_keys('up').
          send_string('" up-line-or-beginning-search').
          send_keys('enter')
      end
    end

    it 'should show previous history entries' do
      with_history(
        'echo foo',
        'echo bar',
        'echo baz'
      ) do
        session.clear_screen
        3.times { session.send_keys('up') }
        wait_for { session.content }.to eq("echo foo")
      end
    end
  end

  describe 'pressing ^C after fetching a suggestion' do
    before do
      skip 'Workaround does not work below v5.0.8' if session.zsh_version < Gem::Version.new('5.0.8')
    end

    it 'terminates the prompt and begins a new one' do
      session.send_keys('e')
      sleep 0.1
      session.send_keys('C-c')
      sleep 0.1
      session.send_keys('echo')

      wait_for { session.content }.to eq("e\necho")
    end
  end
end


