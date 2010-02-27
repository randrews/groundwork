require File.join(File.dirname(__FILE__),"..","lib","groundwork.rb")
require "fileutils"

describe "Options" do

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

    it "should understand options" do
        recipe = Groundwork::Recipe.new(%w{blah --foo bar}) do
            options do
                opt :foo, "Foo mode", :type=>:string
            end
        end

        recipe.instance_variable_get("@name").should=="blah"
        recipe.instance_variable_get("@foo").should=="bar"
    end

    it "should pull the name when there are no options" do
        recipe = Groundwork::Recipe.new(["blah"]) do
            file "foo"
        end

        recipe.instance_variable_get("@name").should=="blah"
    end

    it "should set the name to nil if no name is given, without options" do
        recipe = Groundwork::Recipe.new([]) do
            file "foo"
        end

        recipe.instance_variable_get("@name").should be_nil
    end

    it "should set the name to nil if no name is given, with options" do
        recipe = Groundwork::Recipe.new(%w{-f bar}) do
            options do
                opt :foo, "Foo mode", :type=>:string
            end
        end

        recipe.instance_variable_get("@name").should be_nil
    end

    it "should handle options in required_files" do
        lambda{
            reqs = Groundwork::Recipe.required_files do
                options do
                    opt :foo, "Foo mode", :type=>:string
                end

                file "foo", :from => "foo"
            end

            reqs.should==["foo"]
        }.should_not raise_error
    end
end
