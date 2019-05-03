describe 'a suggestion' do
  let(:term_opts) { { width: 200 } }
  let(:long_command) { "echo #{'a' * 100}" }

  around do |example|
    with_history(long_command) { example.run }
  end

  it 'is provided for any buffer length' do
    session.send_string(long_command[0...-1])
    wait_for { session.content }.to eq(long_command)
  end

  context 'when ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE is specified' do
    let(:buffer_max_size) { 10 }
    let(:options) { ["ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=#{buffer_max_size}"] }

    it 'is provided when the buffer is shorter than the specified length' do
      session.send_string(long_command[0...(buffer_max_size - 1)])
      wait_for { session.content }.to eq(long_command)
    end

    it 'is provided when the buffer is equal to the specified length' do
      session.send_string(long_command[0...(buffer_max_size)])
      wait_for { session.content }.to eq(long_command)
    end

    it 'is not provided when the buffer is longer than the specified length'
  end
end
