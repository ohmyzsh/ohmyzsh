describe 'the `autosuggest-toggle` widget' do
  before do
    session.run_command('bindkey ^B autosuggest-toggle')
  end

  it 'toggles suggestions' do
    with_history('echo world', 'echo hello') do
      session.send_string('echo')
      wait_for { session.content }.to eq('echo hello')

      session.send_keys('C-b')
      wait_for { session.content }.to eq('echo')

      session.send_string(' h')
      sleep 1
      expect(session.content).to eq('echo h')

      session.send_keys('C-b')
      wait_for { session.content }.to eq('echo hello')

      session.send_keys('C-h')
      session.send_string('w')
      wait_for { session.content }.to eq('echo world')
    end
  end
end
