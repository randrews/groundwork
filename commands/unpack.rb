module Groundwork
    module Commands
        def self.unpack args
            cmd_opts = Trollop::options(args) do
                opt :force, "Delete directory if exists", :default=>false
                banner <<-STR
Usage:
      groundwork unpack <name>

Expands an installed recipe to the current directory
STR
            end

            raise RuntimeError.new("Recipe not found: #{args[0]}") unless Groundwork.known_recipes[args[0]]

            if File.exists?(args[0])
                if cmd_opts[:force]
                    FileUtils.rm_rf args[0]
                else
                    raise RuntimeError.new("Directory already exists: #{args[0]}\nUse -f to replace")
                end
            end

            Groundwork::Recipe.unpack args[0], Groundwork.known_recipes[args[0]]
        end
    end
end
