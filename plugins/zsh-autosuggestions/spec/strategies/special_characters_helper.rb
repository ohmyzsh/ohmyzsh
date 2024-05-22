shared_examples 'special characters' do
  describe 'a special character in the buffer should be treated like any other character' do
    it 'asterisk' do
      with_history('echo "hello*"', 'echo "hello."') do
        session.send_string('echo "hello*')
        wait_for { session.content }.to eq('echo "hello*"')
      end
    end

    it 'question mark' do
      with_history('echo "hello?"', 'echo "hello."') do
        session.send_string('echo "hello?')
        wait_for { session.content }.to eq('echo "hello?"')
      end
    end

    it 'backslash' do
      with_history('echo "hello\nworld"') do
        session.send_string('echo "hello\\')
        wait_for { session.content }.to eq('echo "hello\nworld"')
      end
    end

    it 'double backslash' do
      with_history('echo "\\\\"') do
        session.send_string('echo "\\\\')
        wait_for { session.content }.to eq('echo "\\\\"')
      end
    end

    it 'tilde' do
      with_history('echo ~/foo') do
        session.send_string('echo ~')
        wait_for { session.content }.to eq('echo ~/foo')
      end
    end

    it 'parentheses' do
      with_history('echo "$(ls foo)"') do
        session.send_string('echo "$(')
        wait_for { session.content }.to eq('echo "$(ls foo)"')
      end
    end

    it 'square bracket' do
      with_history('echo "$history[123]"') do
        session.send_string('echo "$history[')
        wait_for { session.content }.to eq('echo "$history[123]"')
        session.send_string('123]')
        wait_for { session.content }.to eq('echo "$history[123]"')
      end
    end

    it 'octothorpe' do
      with_history('echo "#yolo"') do
        session.send_string('echo "#')
        wait_for { session.content }.to eq('echo "#yolo"')
      end
    end

    it 'caret' do
      with_history('echo "^A"', 'echo "^B"') do
        session.send_string('echo "^A')
        wait_for { session.content }.to eq('echo "^A"')
      end
    end

    it 'dash' do
      with_history('-foo() {}') do
        session.send_string('-')
        wait_for { session.content }.to eq('-foo() {}')
      end
    end
  end
end
