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

        # All it should create is the directory and the recipe
        File.directory?("test").should be_true
        File.exists?("test/test.recipe.rb").should be_true
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

    it "should print out the recipe file" do
        File.open("recipe", "w") do |f|
            f.puts "file 'foo', :from=>'file1'"
        end

        File.open("file1","w"){|f| f.print("blah")}

        recipe = Groundwork::Recipe.compile_file("recipe")
        File.open("compiled","w"){|f| f.print recipe }

        Groundwork::Recipe.unpack("test", "compiled")

        File.exists?("test/test.recipe.rb").should be_true

        # Not only should it exist, it shouldn't have the
        # data block in it
        File.read("test/test.recipe.rb").should==File.read("recipe")
    end

    it "should unpack external files in subdirectories" do
        File.open("recipe", "w") do |f|
            f.puts "file 'foo', :from=>'a/b/file1'"
        end

        FileUtils.mkdir_p "a/b"
        File.open("a/b/file1","w"){|f| f.print("blah")}

        recipe = Groundwork::Recipe.compile_file("recipe")
        File.open("compiled","w"){|f| f.print recipe }

        Groundwork::Recipe.unpack("test", "compiled")

        File.exists?("test/a/b/file1").should be_true
        File.read("test/a/b/file1").should=="blah"
    end

    it "should evaluate files generated in directories, even if the directories themselves don't get made" do
        File.open("recipe", "w") do |f|
            f.puts "directory 'dir1' do"
            f.puts "    file 'foo', :from=>'file1'"
            f.puts "end"
        end

        File.open("file1","w"){|f| f.print("blah")}

        recipe = Groundwork::Recipe.compile_file("recipe")
        File.open("compiled","w"){|f| f.print recipe }

        Groundwork::Recipe.unpack("test", "compiled")

        File.exists?("test/file1").should be_true
        File.read("test/file1").should=="blah"
    end

    it "should unpack files mentioned in a possible" do
        File.open("recipe", "w") do |f|
            f.puts "possible \"file1\""
        end

        File.open("file1","w"){|f| f.print("blah")}

        recipe = Groundwork::Recipe.compile_file("recipe")
        File.open("compiled","w"){|f| f.print recipe }

        Groundwork::Recipe.unpack("test", "compiled")

        File.exists?("test/file1").should be_true
        File.read("test/file1").should=="blah"
    end

end
