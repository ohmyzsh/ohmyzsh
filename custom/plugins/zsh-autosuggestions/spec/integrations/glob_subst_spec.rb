describe 'with `GLOB_SUBST` option set' do
  let(:after_sourcing) do
    -> {
      session.run_command('setopt GLOB_SUBST')
    }
  end

  it 'error messages are not printed' do
    session.send_string('[[')
    wait_for { session.content }.to eq('[[')
  end
end
