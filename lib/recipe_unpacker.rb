module Groundwork
    class RecipeUnpacker < Recipe
        def directory *args, &block
            FileUtils.mkdir_p File.join(args)
            FileUtils.cd(File.join(args), &block) if block_given?
        end

        def file name, opts = nil
            name = File.join(name)
            if opts.is_a? Hash
                if opts[:from]
                    File.open(opts[:from],"w"){|f| f.print read_file(opts[:from]) }
                elsif opts[:from_erb]
                    File.open(opts[:from_erb],"w"){|f| f.print read_file(opts[:from_erb]) }
                end
            end
        end

        def method_missing *args ; end
    end
end
