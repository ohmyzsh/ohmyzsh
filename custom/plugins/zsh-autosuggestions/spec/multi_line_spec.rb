describe 'a multi-line suggestion' do
  it 'should be displayed on multiple lines' do
    with_history(-> {
      session.send_string('echo "')
      session.send_keys('enter')
      session.send_string('"')
      session.send_keys('enter')
    }) do
      session.send_keys('e')
      wait_for { session.content }.to eq("echo \"\n\"")
    end
  end
end
