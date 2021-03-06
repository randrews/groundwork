require "abbrev"

module Groundwork
  GROUNDWORK_VERSION = File.read(File.join(File.dirname(__FILE__), "..", "VERSION"))
  COMMANDS = Dir[File.join(File.dirname(__FILE__),"..","commands","*.rb")].map{|file| File.basename(file,".rb") }

  def self.parse_options opts=ARGV
    global_opts = Trollop::options(opts) do
      banner <<-STR
Usage:
      groundwork [global_options] <command> [command_options]

Commands:
      generate - Generate a recipe for the current directory
      compile  - Compile a .recipe.rb file into a .recipe
      install  - Install a compiled .recipe file into ~/.groundwork
      list     - List all recipes

      Use "groundwork <command> -h" for command-specific help

Global options are:
STR
      version GROUNDWORK_VERSION
      stop_on_unknown
    end

    cmd=short_for(opts.shift)

    return({ :options=>global_opts,
             :command=>cmd,
             :remainder=>opts
           })
  end

  def self.short_for cmd_start, all_commands=(COMMANDS | known_recipes.keys)
    return cmd_start unless cmd_start
    return cmd_start if all_commands.index(cmd_start)

    completions = all_commands.abbrev(cmd_start)
    if completions[cmd_start]
      completions[cmd_start]
    elsif completions.values.uniq.empty?
      raise RuntimeError.new("Unknown command \"#{cmd_start}\".")
    else
      raise RuntimeError.new("\"#{cmd_start}\" is ambiguous. Which did you mean:\n\t"+cmd_poss.join("\n\t"))
    end
  end
end
