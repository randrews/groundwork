require 'fileutils'

task :default => :test

desc "Delete temp and generated files"
task :clean do
  files=Dir["**/*~"]
  puts "Removing #{files.size} Emacs temp file#{(files.size==1?'':'s')}"
  files.each do |tmp|
    FileUtils.rm tmp
  end

  puts "Removing built gem"
  `rm -f *.gem`
  `rm -f recipes/gem.recipe`
end

desc "Run all tests"
task :test do
  exec "spec --color test/*.rb"
end

desc "Create a gem"
task :gem => "recipes/gem.recipe" do
  `rm -f groundwork-*.gem`
  `gem build groundwork.gemspec`
end

desc "Install groundwork"
task :install=>:gem do
  `gem install --force groundwork-*.gem`
end

desc "Bump version number"
task :bump do
    new_version = ENV["VERSION"] ? ENV["VERSION"] : File.read("VERSION").succ
    File.open("VERSION","w") do |f|
        f.print new_version
    end

    puts "Bumped version to #{new_version}"
end

##################################################

file "recipes/gem.recipe" do
    require "lib/groundwork.rb"

    FileUtils.cd "recipes/gem" do
        @compiled = Groundwork::Recipe.compile_file "gem.recipe.rb"
    end

    File.open("recipes/gem.recipe","w"){|f| f.print @compiled }
end
