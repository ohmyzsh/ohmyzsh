shared_examples 'special characters' do
  describe 'a special character in the buffer' do
    it 'should be treated like any other character' do
      with_history('echo "hello*"', 'echo "hello."') do
        session.send_string('echo "hello*')
        wait_for { session.content }.to eq('echo "hello*"')
      end

      with_history('echo "hello?"', 'echo "hello."') do
        session.send_string('echo "hello?')
        wait_for { session.content }.to eq('echo "hello?"')
      end

      with_history('echo "hello\nworld"') do
        session.send_string('echo "hello\\')
        wait_for { session.content }.to eq('echo "hello\nworld"')
      end

      with_history('echo "\\\\"') do
        session.send_string('echo "\\\\')
        wait_for { session.content }.to eq('echo "\\\\"')
      end

      with_history('echo ~/foo') do
        session.send_string('echo ~')
        wait_for { session.content }.to eq('echo ~/foo')
      end

      with_history('echo "$(ls foo)"') do
        session.send_string('echo "$(')
        wait_for { session.content }.to eq('echo "$(ls foo)"')
      end

      with_history('echo "$history[123]"') do
        session.send_string('echo "$history[')
        wait_for { session.content }.to eq('echo "$history[123]"')
        session.send_string('123]')
        wait_for { session.content }.to eq('echo "$history[123]"')
      end

      with_history('echo "#yolo"') do
        session.send_string('echo "#')
        wait_for { session.content }.to eq('echo "#yolo"')
      end

      with_history('echo "#foo"', 'echo $#abc') do
        session.send_string('echo "#')
        wait_for { session.content }.to eq('echo "#foo"')
      end

      with_history('echo "^A"', 'echo "^B"') do
        session.send_string('echo "^A')
        wait_for { session.content }.to eq('echo "^A"')
      end

      with_history('-foo() {}') do
        session.send_string('-')
        wait_for { session.content }.to eq('-foo() {}')
      end
    end
  end
end
