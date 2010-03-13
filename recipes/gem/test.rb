require File.join(File.dirname(__FILE__),"..","lib","<%=@name%>.rb")
require "fileutils"

describe "Something" do

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

    it "should do something" do
        true.should be_true
    end
end
