describe 'the `autosuggest-disable` widget' do
  before do
    session.run_command('bindkey ^B autosuggest-disable')
  end

  it 'disables suggestions and clears the suggestion' do
    with_history('echo hello') do
      session.send_string('echo')
      wait_for { session.content }.to eq('echo hello')

      session.send_keys('C-b')
      wait_for { session.content }.to eq('echo')

      session.send_string(' h')
      sleep 1
      expect(session.content).to eq('echo h')
    end
  end
end
