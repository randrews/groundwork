module Groundwork
  module Commands
    def self.unpack args
      cmd_opts = Trollop::options(args) do
        banner <<-STR
Usage:
      groundwork unpack <name>

Expands an installed recipe to the current directory
STR
      end

      
    end
  end
end
