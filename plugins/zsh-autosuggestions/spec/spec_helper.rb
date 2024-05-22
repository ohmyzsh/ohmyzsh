require 'pry'
require 'rspec/wait'
require 'terminal_session'
require 'tempfile'

RSpec.shared_context 'terminal session' do
  let(:term_opts) { {} }
  let(:session) { TerminalSession.new(term_opts) }
  let(:before_sourcing) { -> {} }
  let(:after_sourcing) { -> {} }
  let(:options) { [] }

  around do |example|
    before_sourcing.call
    session.run_command(['source zsh-autosuggestions.zsh', *options].join('; '))
    after_sourcing.call
    session.clear_screen

    example.run

    session.destroy
  end

  def with_history(*commands, &block)
    Tempfile.create do |f|
      f.write(commands.map{|c| c.gsub("\n", "\\\n")}.join("\n"))
      f.flush

      session.run_command('fc -p')
      session.run_command("fc -R #{f.path}")

      session.clear_screen

      yield block

      session.send_keys('C-c')
      session.run_command('fc -P')
    end
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
