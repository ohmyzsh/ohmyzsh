describe 'when using vi mode' do
  let(:before_sourcing) do
    -> do
      session.run_command('bindkey -v')
    end
  end

  describe 'moving the cursor after exiting insert mode' do
    it 'should not clear the current suggestion' do
      with_history('foobar foo') do
        session.
          send_string('foo').
          send_keys('escape').
          send_keys('h')

        wait_for { session.content }.to eq('foobar foo')
      end
    end
  end

  describe '`vi-forward-word-end`' do
    it 'should accept through the end of the current word' do
      with_history('foobar foo') do
        session.
          send_string('foo').
          send_keys('escape').
          send_keys('e'). # vi-forward-word-end
          send_keys('a'). # vi-add-next
          send_string('baz')

        wait_for { session.content }.to eq('foobarbaz')
      end
    end
  end

  describe '`vi-forward-word`' do
    it 'should accept through the first character of the next word' do
      with_history('foobar foo') do
        session.
          send_string('foo').
          send_keys('escape').
          send_keys('w'). # vi-forward-word
          send_keys('a'). # vi-add-next
          send_string('az')

        wait_for { session.content }.to eq('foobar faz')
      end
    end
  end

  describe '`vi-find-next-char`' do
    it 'should accept through the next occurrence of the character' do
      with_history('foobar foo') do
        session.
          send_string('foo').
          send_keys('escape').
          send_keys('f'). # vi-find-next-char
          send_keys('o').
          send_keys('a'). # vi-add-next
          send_string('b')

        wait_for { session.content }.to eq('foobar fob')
      end
    end
  end
end

