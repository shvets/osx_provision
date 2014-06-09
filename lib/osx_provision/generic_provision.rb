require 'json'
require "highline"

require 'text_interpolator'
require 'script_executor/executable'
require 'script_executor/script_locator'

class GenericProvision
  include Executable, ScriptLocator

  attr_reader :interpolator, :env, :script_list, :server_info

  def initialize config_file_name, scripts_file_name
    @interpolator = TextInterpolator.new

    @env = read_config(config_file_name)

    @script_list = scripts(File.expand_path(scripts_file_name, File.dirname(__FILE__)))

    @server_info = env[:node] ? env[:node] : {}
  end

  protected

  def read_config config_file_name
    hash = JSON.parse(File.read(config_file_name), :symbolize_names => true)

    interpolator.interpolate hash
  end

  def terminal
    @terminal ||= HighLine.new
  end

  def ask_password message
    terminal.ask(message) { |q| q.echo = "*" }
  end

  def run server_info, script_name, params
    execute(server_info) { evaluate_script_body(script_list[script_name], params, :string) }
  end

  def run_command server_info, command
    execute(server_info.merge({script: command}))
  end

end
