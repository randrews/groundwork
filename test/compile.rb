require File.join(File.dirname(__FILE__),"..","groundwork.rb")
require "fileutils"

describe "Compile" do

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

  it "should build a script" do
    File.open("foo","w"){|f| f.print "Contents of the file" }
    File.open("recipe","w"){|f|
      f.puts "directory 'blah' do"
      f.puts "  file 'file1', :from=>'foo'"
      f.puts "end"
    }

    recipe = nil
    lambda{recipe = Groundwork.compile("recipe") }.should_not raise_error
    recipe.should_not be_nil
  end

  it "should run a script correctly" do
    File.open("foo","w"){|f| f.print "Contents of the file" }
    File.open("recipe","w"){|f|
      f.puts "directory 'blah' do"
      f.puts "  file 'file1', :from=>'foo'"
      f.puts "end"
    }

    recipe = Groundwork.compile("recipe")
    File.open("compiled","w"){|f| f.print recipe }

    FileUtils.mkdir "tmp"
    FileUtils.cd "tmp" do
      lambda{ Groundwork.run "../compiled" }.should_not raise_error
      File.exists?("blah/file1").should be_true
      File.read("blah/file1").should == "Contents of the file"
    end
  end
end
