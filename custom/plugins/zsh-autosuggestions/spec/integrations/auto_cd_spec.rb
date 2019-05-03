describe 'with `AUTO_CD` option set' do
  let(:after_sourcing) do
    -> {
      session.run_command('setopt AUTO_CD')
      session.run_command('autoload compinit && compinit')
    }
  end

  it 'directory names are still completed' do
    session.send_string('sr')
    session.send_keys('C-i')
    wait_for { session.content }.to eq('src/')
  end
end
