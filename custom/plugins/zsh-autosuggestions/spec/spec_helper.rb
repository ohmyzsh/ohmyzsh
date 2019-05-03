require 'pry'
require 'rspec/wait'
require 'terminal_session'

RSpec.shared_context 'terminal session' do
  let(:term_opts) { {} }
  let(:session) { TerminalSession.new(term_opts) }
  let(:before_sourcing) { -> {} }
  let(:after_sourcing) { -> {} }
  let(:options) { [] }

  around do |example|
    before_sourcing.call
    session.run_command(options.join('; '))
    session.run_command('source zsh-autosuggestions.zsh')
    after_sourcing.call
    session.clear_screen

    example.run

    session.destroy
  end

  def with_history(*commands, &block)
    session.run_command('fc -p')

    commands.each do |c|
      c.respond_to?(:call) ? c.call : session.run_command(c)
    end

    session.clear_screen

    yield block

    session.send_keys('C-c')
    session.run_command('fc -P')
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.wait_timeout = 2

  config.include_context 'terminal session'
end
