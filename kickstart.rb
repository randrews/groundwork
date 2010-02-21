module Kickstart
  def directory *name, &block
    FileUtils.mkdir_p File.join(name)
    if block_given?
      FileUtils.cd File.join(name), &block
    end
  end
end
