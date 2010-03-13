module Groundwork
    class RecipeUnpacker < Recipe
        def directory *args, &block
            yield if block_given?
        end

        def file name, opts = nil
            if opts.is_a? Hash
                if filename = (opts[:from] || opts[:from_erb])
                    FileUtils.mkdir_p File.dirname(filename)
                    File.open(filename,"w"){|f| f.print read_file(filename) }
                end
            end
        end

        def possible filename
            File.open(filename,"w"){|f| f.print read_file(filename) }
        end

        def method_missing *args ; end
    end
end
