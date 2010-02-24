require File.join(File.dirname(__FILE__),"..","lib","groundwork.rb")
require "fileutils"

describe "Command" do
  include Groundwork

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

  it "should parse commands" do
    opts = Groundwork.parse_options(["generate"])

    opts[:command].should=="generate"
    opts[:options].should=={:version=>false, :help=>false}
  end

  it "should fail on a bad command" do
    lambda{ Groundwork.parse_options(["badcommand"]) }.should raise_error(RuntimeError)
  end

  it "should leave behind the remainder of the args for the command" do
    opts = Groundwork.parse_options(["generate","foo"])

    opts[:remainder].should==["foo"]
  end
end
