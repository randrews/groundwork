require File.join(File.dirname(__FILE__),"..","kickstart.rb")
require "fileutils"

describe "Directories" do
  include Kickstart

  before :all do
    @pwd = FileUtils.pwd
    @scratch = File.join(File.dirname(__FILE__),"scratch")
    FileUtils.mkdir @scratch
    FileUtils.cd @scratch
  end

  after :all do
    FileUtils.cd @pwd
    FileUtils.rm_rf @scratch
  end

  it "should create a directory" do
    directory "foo"

    File.directory?("foo").should be_true
  end
end
