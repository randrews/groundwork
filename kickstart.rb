class Kickstart
  def initialize &block
    if block_given?
      instance_eval &block
    end
  end

  def directory *name, &block
    FileUtils.mkdir_p File.join(name)
    if block_given?
      FileUtils.cd File.join(name), &block
    end
  end

  # If opts is a string, it's the contents of the file, verbatim
  # If opts is a hash, it must contain either:
  # * :from, copies the text of the given filename verbatim
  # * :from_erb, uses the text of the filename as an erb template
  # * :erb, uses the given string as an erb template
  def file name, opts = nil
    name = File.join(name)
    File.open(File.join(name),"w") do |file|
      if opts.is_a? String
        file.print opts
      elsif opts.is_a? Hash
        if opts[:from]
        elsif opts[:from_erb]
        elsif opts[:erb]
        end
      elsif opts.nil?
        # write nothing
      else
        raise ArgumentError.new
      end
      end
  end
end
