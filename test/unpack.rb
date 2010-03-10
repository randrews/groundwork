require File.join(File.dirname(__FILE__),"..","lib","groundwork.rb")
require "fileutils"

describe "Unpack" do

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

    it "should unpack a recipe with no external files" do
        File.open("recipe","w") do |f|
            f.puts "directory 'foo'"
            f.puts "directory('bar') do"
            f.puts "    file 'one', 'one'"
            f.puts "    directory('baz'){ file 'two', :erb=>'<%= 2+2 %>' }"
            f.puts "end"
        end

        Groundwork::Recipe.unpack("test", "recipe")

        File.directory?("test/foo").should be_true
        File.directory?("test/bar").should be_true
        File.directory?("test/bar/baz").should be_true
    end

    it "should unpack external files" do
        File.open("recipe", "w") do |f|
            f.puts "file \"foo\", :from=>\"file1\""
        end

        File.open("file1","w"){|f| f.print("blah")}

        recipe = Groundwork::Recipe.compile_file("recipe")
        File.open("compiled","w"){|f| f.print recipe }

        Groundwork::Recipe.unpack("test", "compiled")

        File.exists?("test/file1").should be_true
        File.read("test/file1").should=="blah"
    end
end
