require File.join(File.dirname(__FILE__),"..","kickstart.rb")
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

    files = Kickstart.required_files do
      file "one", :from=>"foo"

      directory "blah" do
        file "two", :from_erb=>"bar"
      end
    end

    files.should==["foo", "bar"]
  end
end
