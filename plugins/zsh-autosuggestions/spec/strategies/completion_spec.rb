describe 'the `completion` suggestion strategy' do
  let(:options) { ['ZSH_AUTOSUGGEST_STRATEGY=completion'] }
  let(:before_sourcing) do
    -> do
      session.
        run_command('autoload compinit && compinit').
        run_command('_foo() { compadd bar; compadd bat }').
        run_command('_num() { compadd two; compadd three }').
        run_command('compdef _foo baz').
        run_command('compdef _num one')
    end
  end

  it 'suggests the first completion result' do
    session.send_string('baz ')
    wait_for { session.content }.to eq('baz bar')
  end

  it 'does not add extra carriage returns when prefix has a line feed' do
    skip '`stty` does not work inside zpty below zsh version 5.0.3' if session.zsh_version < Gem::Version.new('5.0.3')
    session.send_string('baz \\').send_keys('C-v', 'C-j')
    wait_for { session.content }.to eq("baz \\\nbar")
  end

  context 'when `_complete` is aliased' do
    let(:before_sourcing) do
      -> do
        session.
          run_command('autoload compinit && compinit').
          run_command('_foo() { compadd bar; compadd bat }').
          run_command('compdef _foo baz').
          run_command('alias _complete=_complete')
      end
    end

    it 'suggests the first completion result' do
      session.send_string('baz ')
      wait_for { session.content }.to eq('baz bar')
    end
  end

  context 'when ZSH_AUTOSUGGEST_COMPLETION_IGNORE is set to a pattern' do
    let(:options) { ['ZSH_AUTOSUGGEST_STRATEGY=completion', 'ZSH_AUTOSUGGEST_COMPLETION_IGNORE="one *"'] }

    it 'makes suggestions when the buffer does not match the pattern' do
      session.send_string('baz ')
      wait_for { session.content }.to eq('baz bar')
    end

    it 'does not make suggestions when the buffer matches the pattern' do
      session.send_string('one t')
      sleep 1
      expect(session.content).to eq('one t')
    end
  end

  context 'when async mode is enabled' do
    let(:options) { ['ZSH_AUTOSUGGEST_USE_ASYNC=true', 'ZSH_AUTOSUGGEST_STRATEGY=completion'] }

    it 'suggests the first completion result' do
      session.send_string('baz ')
      wait_for { session.content }.to eq('baz bar')
    end

    it 'does not add extra carriage returns when prefix has a line feed' do
      skip '`stty` does not work inside zpty below zsh version 5.0.3' if session.zsh_version < Gem::Version.new('5.0.3')
      session.send_string('baz \\').send_keys('C-v', 'C-j')
      wait_for { session.content }.to eq("baz \\\nbar")
    end
  end
end

