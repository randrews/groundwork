require "abbrev"

module Groundwork
  def self.parse_options opts=ARGV
    global_opts = Trollop::options(opts) do
      banner <<-STR
Usage:
       groundwork [global_options] command [command_options]
Currently, the only implemented commands are "generate", which generates a recipe for the current directory, and "compile", which compiles a recipe with all the files it references.
Options are:
STR
      version "0.0.3"
      stop_on_unknown
    end

    cmd=short_for(opts.shift)

    return({ :options=>global_opts,
             :command=>cmd,
             :remainder=>opts
           })
  end

  def self.short_for cmd_start, all_commands=["generate", "compile"]
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
