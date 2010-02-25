module Groundwork
  module Commands
    def self.compile args
      cmd_opts = Trollop::options(args) do
        banner <<-STR
Usage:
      groundwork compile [options] filename.recipe.rb

Compiles a .recipe.rb, including all referenced files into it.

Options are:
STR
        opt :force, "Overwrite .recipe file if exists", :default=>false
        opt :print, "Instead of storing in a file, print the recipe to stdout", :default=>false
        opt :chdir, "Before running, cd to the given directory", :default=>FileUtils.pwd
      end

      input = args.shift
      raise RuntimeError.new("Cannot open #{input}") if input && !File.exists?(input)

      compiled = ""
      FileUtils.cd(cmd_opts[:chdir]) do
        compiled = if input
                     Groundwork::Recipe.compile_file input
                   else
                     Groundwork::Recipe.compile STDIN.read, FileUtils.pwd
                   end
      end

      if cmd_opts[:print]
        puts compiled
      else
        name = args.shift || if input
                               File.basename(input,".recipe.rb")
                             else
                               File.basename(FileUtils.pwd)
                             end

        if File.exists?(name+".recipe") && !cmd_opts[:force]
          raise RuntimeError.new("File already exists: #{name}.recipe\nUse -f to overwrite")
        end

        File.open(name+".recipe","w"){|f| f.print compiled}
      end
    end
  end
end
