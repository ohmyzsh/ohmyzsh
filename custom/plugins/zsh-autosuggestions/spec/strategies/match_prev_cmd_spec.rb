require 'strategies/special_characters_helper'

describe 'the `match_prev_cmd` strategy' do
  let(:options) { ['ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd'] }

  let(:history) { [
    'echo what',
    'ls foo',
    'echo what',
    'ls bar',
    'ls baz',
    'echo what'
  ] }

  it 'suggests the last matching history entry after the previous command' do
    with_history(*history) do
      session.send_string('ls')
      wait_for { session.content }.to eq('ls bar')
    end
  end

  context 'when ZSH_AUTOSUGGEST_HISTORY_IGNORE is set to a pattern' do
    let(:options) { ['ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd', 'ZSH_AUTOSUGGEST_HISTORY_IGNORE="* bar"'] }

    it 'does not make suggestions that match the pattern' do
      with_history(*history) do
        session.send_string('ls')
        wait_for { session.content }.to eq('ls foo')
      end
    end
  end

  include_examples 'special characters'
end
