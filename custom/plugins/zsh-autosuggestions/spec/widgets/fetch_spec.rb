describe 'the `autosuggest-fetch` widget' do
  context 'when suggestions are disabled' do
    before do
      session.
        run_command('bindkey ^B autosuggest-disable').
        run_command('bindkey ^F autosuggest-fetch').
        send_keys('C-b')
    end

    it 'will fetch and display a suggestion' do
      with_history('echo hello') do
        session.send_string('echo h')
        sleep 1
        expect(session.content).to eq('echo h')

        session.send_keys('C-f')
        wait_for { session.content }.to eq('echo hello')

        session.send_string('e')
        wait_for { session.content }.to eq('echo hello')
      end
    end
  end
end
