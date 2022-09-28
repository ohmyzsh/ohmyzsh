describe 'the `autosuggest-enable` widget' do
  before do
    session.
      run_command('typeset -g _ZSH_AUTOSUGGEST_DISABLED').
      run_command('bindkey ^B autosuggest-enable')
  end

  it 'enables suggestions and fetches a suggestion' do
    with_history('echo hello') do
      session.send_string('e')
      sleep 1
      expect(session.content).to eq('e')

      session.send_keys('C-b')
      session.send_string('c')
      wait_for { session.content }.to eq('echo hello')
    end
  end

  context 'invoked on an empty buffer' do
    it 'does not fetch a suggestion' do
      with_history('echo hello') do
        session.send_keys('C-b')
        sleep 1
        expect(session.content).to eq('')
      end
    end
  end

  context 'invoked on a non-empty buffer' do
    it 'fetches a suggestion' do
      with_history('echo hello') do
        session.send_string('e')
        sleep 1
        expect(session.content).to eq('e')

        session.send_keys('C-b')
        wait_for { session.content }.to eq('echo hello')
      end
    end
  end
end
