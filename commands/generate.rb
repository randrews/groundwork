module Groundwork
  module Commands
    def self.generate args

      cmd_opts = Trollop::options(args) do
        banner <<-STR
Usage:
      groundwork generate [options] filename

Generates a basic .recipe.rb file, which you can modify, from the current directory

Options are:
STR
        opt :force, "Overwrite .recipe.rb file if exists", :default=>false
        opt :ignore, "Ignore files matching these filename patterns", :type=>:strings
        opt :print, "Instead of storing in a file, print the recipe to stdout", :default=>false
        opt :chdir, "Before running, cd to the given directory", :default=>FileUtils.pwd
      end

      recipe = ""
      FileUtils.cd(cmd_opts[:chdir]) do
        recipe = Groundwork::Recipe.generate FileUtils.pwd, :ignore => cmd_opts[:ignore]
      end

      if cmd_opts[:print]
        puts recipe
      else
        name = args.shift || File.basename(FileUtils.pwd)

        if File.exists?(name+".recipe.rb") && !cmd_opts[:force]
          raise RuntimeError.new("File already exists: #{name}.recipe.rb\nUse -f to overwrite")
        end

        File.open(name+".recipe.rb","w"){|f| f.print recipe}
      end
    end
  end
end
