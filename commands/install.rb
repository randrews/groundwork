module Groundwork
  module Commands
    def self.install args
      cmd_opts = Trollop::options(args) do
        banner <<-STR
Usage:
      groundwork install [options] filename.recipe

Installs a recipe into ~/.groundwork

Options are:
STR
        opt :force, "Overwrite recipe if it already exists", :default=>false
        opt :name, "Specify a name for the recipe other than the filename", :default=>false
      end

      file = args.shift
      raise RuntimeError.new("No input file given") unless file
      raise RuntimeError.new("Cannot open #{file}") unless File.exists?(file)

      dot_groundwork = File.expand_path("~/.groundwork")
      FileUtils.mkdir(dot_groundwork) unless File.directory?(dot_groundwork)

      if File.exists?(File.join(dot_groundwork,File.basename(file))) && !cmd_opts[:force]
        raise RuntimeError.new("Recipe already exists: #{File.basename(file,'.recipe')}\nUse -f to replace")
      end

      FileUtils.cp file, dot_groundwork
    end
  end
end
