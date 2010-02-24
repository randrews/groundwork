require File.join(File.dirname(__FILE__),"..","lib","groundwork.rb")
require "fileutils"

describe "Tarballs" do

  before :each do
    @pwd = FileUtils.pwd
    @scratch = File.join(File.dirname(__FILE__),"scratch")
    FileUtils.mkdir @scratch
    FileUtils.cd @scratch
  end

  after :each do
    FileUtils.cd @pwd
    FileUtils.rm_rf @scratch
  end

  it "should tar/untar a file" do
    File.open("foo","w"){|f| f.print "Contents of the file" }

    str = TarWrapper.compress(["foo"])
    TarWrapper.new(str)["foo"].should=="Contents of the file"
  end
end
