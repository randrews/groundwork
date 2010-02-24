require File.join(File.dirname(__FILE__),"..","lib","groundwork.rb")
require "fileutils"

describe "Directories" do

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
    Groundwork::Groundwork.new do
      directory "foo"
    end

    File.directory?("foo").should be_true
  end

  it "should accept a block" do
    x = false

    Groundwork::Groundwork.new do
      directory "foo" do
        x = true
      end
    end

    x.should be_true
  end

  it "should create subdirectories" do
    Groundwork::Groundwork.new do
      directory "foo" do
        directory "bar"
      end
    end

    File.directory?("foo/bar").should be_true
  end

  it "should make a tree of directories in one call" do
    Groundwork::Groundwork.new do
      directory "foo", "bar"
    end

    File.directory?("foo/bar").should be_true
  end
end
