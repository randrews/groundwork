require File.join(File.dirname(__FILE__),"..","kickstart.rb")
require "fileutils"

describe "Directories" do
  include Kickstart

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

  it "should create a directory" do
    directory "foo"

    File.directory?("foo").should be_true
  end

  it "should accept a block" do
    x = false
    directory "foo" do
      x = true
    end
    x.should be_true
  end

  it "should create subdirectories" do
    directory "foo" do
      directory "bar"
    end

    File.directory?("foo/bar").should be_true
  end

  it "should make a tree of directories in one call" do
    directory "foo", "bar"

    File.directory?("foo/bar").should be_true
  end
end
