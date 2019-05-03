require 'strategies/special_characters_helper'

describe 'the `match_prev_cmd` strategy' do
  let(:options) { ['ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd'] }

  it 'suggests the last matching history entry after the previous command' do
    with_history(
      'echo what',
      'ls foo',
      'echo what',
      'ls bar',
      'ls baz',
      'echo what'
    ) do
      session.send_string('ls')
      wait_for { session.content }.to eq('ls bar')
    end
  end

  include_examples 'special characters'
end
