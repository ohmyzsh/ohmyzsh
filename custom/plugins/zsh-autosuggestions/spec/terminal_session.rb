require 'securerandom'

class TerminalSession
  ZSH_BIN = ENV['TEST_ZSH_BIN'] || 'zsh'

  def initialize(opts = {})
    opts = {
      width: 80,
      height: 24,
      prompt: '',
      term: 'xterm-256color',
      zsh_bin: ZSH_BIN
    }.merge(opts)

    @opts = opts

    cmd="PS1=\"#{opts[:prompt]}\" TERM=#{opts[:term]} #{ZSH_BIN} -f"
    tmux_command("new-session -d -x #{opts[:width]} -y #{opts[:height]} '#{cmd}'")
  end

  def zsh_version
    @zsh_version ||= Gem::Version.new(`#{ZSH_BIN} -c 'echo -n $ZSH_VERSION'`)
  end

  def tmux_socket_name
    @tmux_socket_name ||= SecureRandom.hex(6)
  end

  def run_command(command)
    send_string(command)
    send_keys('enter')

    self
  end

  def send_string(str)
    tmux_command("send-keys -t 0 -l -- '#{str.gsub("'", "\\'")}'")

    self
  end

  def send_keys(*keys)
    tmux_command("send-keys -t 0 #{keys.join(' ')}")

    self
  end

  def paste_string(str)
    tmux_command("set-buffer -- '#{str}'")
    tmux_command("paste-buffer -dpr -t 0")

    self
  end

  def content(esc_seqs: false)
    cmd = 'capture-pane -p -t 0'
    cmd += ' -e' if esc_seqs
    tmux_command(cmd).strip
  end

  def clear_screen
    send_keys('C-l')

    i = 0
    until content == opts[:prompt] || i > 20 do
      sleep(0.1)
      i = i + 1
    end

    self
  end

  def destroy
    tmux_command('kill-session')
  end

  def cursor
    tmux_command("display-message -t 0 -p '\#{cursor_x},\#{cursor_y}'").
      strip.
      split(',').
      map(&:to_i)
  end

  def attach!
    tmux_command('attach-session')
  end

  private

  attr_reader :opts

  def tmux_command(cmd)
    out = `tmux -u -L #{tmux_socket_name} #{cmd}`

    raise("tmux error running: '#{cmd}'") unless $?.success?

    out
  end
end
