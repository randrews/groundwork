module Groundwork
  module Commands
    def self.list args
      cmd_opts = Trollop::options(args) do
        banner <<-STR
Usage:
      groundwork list

Lists all installed recipes
STR
      end

      puts Groundwork.known_recipes.keys.join("\n")
    end
  end
end
