require File.join(File.dirname(__FILE__),"..","kickstart.rb")
require "fileutils"

describe "Files" do

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

  it "should create an empty file" do
    Kickstart.new do
      file "foo"
    end

    File.exists?("foo").should be_true
  end

  it "should create a file with a string in it" do
    Kickstart.new do
      file "foo", "bar"
    end

    File.exists?("foo").should be_true
    File.read("foo").should=="bar"
  end

  it "should create a file with ERb in it" do
    Kickstart.new do
      file "foo", :erb=><<-STR
<% 10.times do %>foo<% end %>
STR
    end

    File.read("foo").strip.should==("foo"*10)
  end
  it "should create a file from a file"
  it "should create a file from a file with ERb in it"
end