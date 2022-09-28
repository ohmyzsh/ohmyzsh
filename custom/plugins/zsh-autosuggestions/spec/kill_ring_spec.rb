context 'with some items in the kill ring' do
  before do
    session.
      send_string('echo foo').
      send_keys('C-u').
      send_string('echo bar').
      send_keys('C-u')
  end

  describe '`yank-pop`' do
    it 'should cycle through all items in the kill ring' do
      session.send_keys('C-y')
      wait_for { session.content }.to eq('echo bar')

      session.send_keys('escape').send_keys('y')
      wait_for { session.content }.to eq('echo foo')

      session.send_keys('escape').send_keys('y')
      wait_for { session.content }.to eq('echo bar')
    end
  end
end

