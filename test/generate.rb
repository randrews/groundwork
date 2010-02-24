require File.join(File.dirname(__FILE__),"..","lib","groundwork.rb")
require "fileutils"

describe "Generate" do

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

  it "should generate a list of file commands" do
    File.open("file1","w"){|f| f.print "Contents of the file" }
    File.open("file2","w"){|f| f.print "Contents of the file" }
    File.open("file3","w"){|f| f.print "Contents of the file" }

    Groundwork::Recipe.required_files{|| eval Groundwork::Recipe.generate}.should==["file1","file2","file3"]
  end

  it "should generate empty directories" do
    FileUtils.mkdir "foo"

    Groundwork::Recipe.generate.should =~ /directory \"foo\"/
  end

  it "should generate files within directories" do
    File.open("file1","w"){|f| f.print "Contents of the file" }
    FileUtils.mkdir "foo"
    File.open("foo/file2","w"){|f| f.print "Contents of the file" }

    Groundwork::Recipe.required_files{|| eval Groundwork::Recipe.generate}.should==["file1","foo/file2"]
  end

end
