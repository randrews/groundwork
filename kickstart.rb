module Kickstart
  def directory name
    FileUtils.mkdir File.join(name)
  end
end
