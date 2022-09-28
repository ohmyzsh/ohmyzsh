describe 'a multi-line suggestion' do
  it 'should be displayed on multiple lines' do
    with_history("echo \"\n\"") do
      session.send_keys('e')
      wait_for { session.content }.to eq("echo \"\n\"")
    end
  end
end
