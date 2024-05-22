describe 'a running zpty command' do
  let(:before_sourcing) { -> { session.run_command('zmodload zsh/zpty && zpty -b kitty cat') } }

  context 'when using `completion` strategy' do
    let(:options) { ["ZSH_AUTOSUGGEST_STRATEGY=completion"] }

    it 'is not affected' do
      session.send_keys('a').send_keys('C-h')
      session.run_command('zpty -t kitty; echo $?')

      wait_for { session.content }.to end_with("\n0")
    end
  end
end
