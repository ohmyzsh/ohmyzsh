require 'strategies/special_characters_helper'

describe 'the `history` suggestion strategy' do
  it 'suggests the last matching history entry' do
    with_history('ls foo', 'ls bar', 'echo baz') do
      session.send_string('ls')
      wait_for { session.content }.to eq('ls bar')
    end
  end

  context 'when ZSH_AUTOSUGGEST_HISTORY_IGNORE is set to a pattern' do
    let(:options) { ['ZSH_AUTOSUGGEST_HISTORY_IGNORE="* bar"'] }

    it 'does not make suggestions that match the pattern' do
      with_history('ls foo', 'ls bar', 'echo baz') do
        session.send_string('ls')
        wait_for { session.content }.to eq('ls foo')
      end
    end
  end

  include_examples 'special characters'
end
