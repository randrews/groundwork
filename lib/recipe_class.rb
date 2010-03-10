module Groundwork
    class Recipe
        class << self

            # Takes a block and lists the files that that block will require as templates.
            # See Groundwork::Recipe#possible
            def required_files &block
                dummy = Object.new
                files = []

                class << dummy
                    attr_reader :files

                    def directory *args
                        yield if block_given?
                    end

                    def file name, opts=nil
                        @files << opts[:from] if opts[:from]
                        @files << opts[:from_erb] if opts[:from_erb]
                    end

                    def possible name
                        @files << name
                    end

                    def method_missing *args ; end
                end

                dummy.instance_variable_set "@files", []
                dummy.instance_eval &block

                dummy.files
            end

            def compile_file filename
                compile File.read(filename), File.dirname(filename)
            end

            # Takes a script file, finds the files it requires (paths relative to the script file),
            # reads/tars them and returns a string containing the script and the TAR blob, ready
            # to write to a file
            def compile script, in_directory
                out = StringIO.new
                data = nil

                FileUtils.cd(in_directory) do
                    files = required_files do
                        eval script
                    end

                    data = TarWrapper.compress files
                end

                out.puts script
                out.puts ""
                out.puts "__END__"
                out.puts data

                out.string
            end

            # Takes a filename and runs the script contained in it. The file should be
            # the results of Groundwork::Recipe#compile
            def run script_file, args=[]
                (script, data) = File.read(script_file).split("\n__END__\n")

                Groundwork::Recipe.new args do
                    self.tar = data if data
                    eval script
                end
            end

            # Takes a directory and a block, and unpacks the script given in the block into
            # the directory.
            # If the second argument is given, the script is loaded from that filename instead
            # of using the block
            def unpack unpack_to, filename
                (recipe, data) = File.read(filename).split("\n__END__\n")

                FileUtils.mkdir unpack_to

                FileUtils.cd unpack_to do
                    Groundwork::RecipeUnpacker.new do
                        self.tar = data if data
                        eval recipe
                    end
                end
            end

            # Generate a tree of file and directory calls that would create the given
            # directory
            def generate dir = FileUtils.pwd, options = {}
                base = Pathname.new dir

                handle_dir = lambda do |d, output, indent|
                    FileUtils.cd d do
                        Dir["*"].each do |file|
                            rel = Pathname.new(File.join(FileUtils.pwd,file))
                            relpath = rel.relative_path_from(base).to_s

                            next if options[:ignore] && options[:ignore].any?{|p| File.fnmatch(p,relpath) }

                            if File.directory? file
                                if Dir[File.join(file,"*")].empty?
                                    output.puts((" "*indent)+"directory \"#{file}\"")
                                else
                                    output.puts("")
                                    output.puts((" "*indent)+"directory \"#{file}\" do")
                                    handle_dir[file, output, indent+2]
                                    output.puts((" "*indent)+"end")
                                    output.puts("")
                                end
                            else
                                output.puts((" "*indent)+"file \"#{file}\", :from => \"#{relpath}\"")
                            end
                        end
                    end
                end

                str = StringIO.new
                handle_dir[dir, str, 0]
                str.string.gsub(/\n\n+/,"\n\n") # Collapse adjacent blank lines
            end

        end
    end
end
