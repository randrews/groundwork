options do
    opt :bin, "Create a command for this gem", :default=>false
end

possible "bin.rb"

directory @name do
    if @bin
        directory "bin" do
            file @name , :from_erb => "bin.rb"
        end
    end

    file "#{@name}.gemspec", :from_erb => "gemspec.rb"

    directory "lib" do
        file "#{@name}.rb", "# Put your code here"
    end

    file "Rakefile", :from_erb => "Rakefile"
    file "readme.textile", :from_erb => "readme.textile"

    directory "test" do
        file "test.rb", :from_erb => "test.rb"
    end

    file "VERSION", "0.0.1"
end
