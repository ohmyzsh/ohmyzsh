describe 'a suggestion for a given prefix' do
  let(:history_strategy) { '_zsh_autosuggest_strategy_history() { suggestion="history" }' }
  let(:foobar_strategy) { '_zsh_autosuggest_strategy_foobar() { [[ "foobar baz" = $1* ]] && suggestion="foobar baz" }' }
  let(:foobaz_strategy) { '_zsh_autosuggest_strategy_foobaz() { [[ "foobaz bar" = $1* ]] && suggestion="foobaz bar" }' }

  let(:after_sourcing) do
    -> do
      session.run_command(history_strategy)
    end
  end

  it 'by default is determined by calling the `history` strategy function' do
    session.send_string('h')
    wait_for { session.content }.to eq('history')
  end

  context 'when ZSH_AUTOSUGGEST_STRATEGY is set to an array' do
    let(:after_sourcing) do
      -> do
        session.
          run_command(foobar_strategy).
          run_command(foobaz_strategy).
          run_command('ZSH_AUTOSUGGEST_STRATEGY=(foobar foobaz)')
      end
    end

    it 'is determined by the first strategy function to return a suggestion' do
      session.send_string('foo')
      wait_for { session.content }.to eq('foobar baz')

      session.send_string('baz')
      wait_for { session.content }.to eq('foobaz bar')
    end
  end

  context 'when ZSH_AUTOSUGGEST_STRATEGY is set to a string' do
    let(:after_sourcing) do
      -> do
        session.
          run_command(foobar_strategy).
          run_command(foobaz_strategy).
          run_command('ZSH_AUTOSUGGEST_STRATEGY="foobar foobaz"')
      end
    end

    it 'is determined by the first strategy function to return a suggestion' do
      session.send_string('foo')
      wait_for { session.content }.to eq('foobar baz')

      session.send_string('baz')
      wait_for { session.content }.to eq('foobaz bar')
    end
  end
end

