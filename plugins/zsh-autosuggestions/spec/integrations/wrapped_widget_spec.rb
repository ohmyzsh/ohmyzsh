describe 'a wrapped widget' do
  let(:widget) { 'backward-delete-char' }

  context 'initialized before sourcing the plugin' do
    let(:before_sourcing) do
      -> do
        session.
          run_command("_orig_#{widget}() { zle .#{widget} }").
          run_command("zle -N orig-#{widget} _orig_#{widget}").
          run_command("#{widget}-magic() { zle orig-#{widget}; BUFFER+=b }").
          run_command("zle -N #{widget} #{widget}-magic")
      end
    end

    it 'executes the custom behavior and the built-in behavior' do
      with_history('foobar', 'foodar') do
        session.send_string('food').send_keys('C-h')
        wait_for { session.content }.to eq('foobar')
      end
    end
  end

  context 'initialized after sourcing the plugin' do
    before do
      session.
        run_command("zle -N orig-#{widget} ${widgets[#{widget}]#*:}").
        run_command("#{widget}-magic() { zle orig-#{widget}; BUFFER+=b }").
        run_command("zle -N #{widget} #{widget}-magic").
        clear_screen
    end

    it 'executes the custom behavior and the built-in behavior' do
      with_history('foobar', 'foodar') do
        session.send_string('food').send_keys('C-h')
        wait_for { session.content }.to eq('foobar')
      end
    end
  end
end
