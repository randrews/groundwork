require File.join(File.dirname(__FILE__),"..","groundwork.rb")
require "fileutils"

describe "Recipes" do

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

  it "should require the proper list of files" do
    File.open("foo","w"){|f| f.print "foo" }
    File.open("bar","w"){|f| f.print "bar" }
    File.open("baz","w"){|f| f.print "baz" }

    files = Groundwork.required_files do
      possible "baz"

      file "one", :from=>"foo"

      directory "blah" do
        file "two", :from_erb=>"bar"
      end

      if false
        file "three", :from=>"fake"
        file "four", :from=>"baz"
      end
    end

    files.sort.should==["foo", "bar", "baz"].sort
  end
end
