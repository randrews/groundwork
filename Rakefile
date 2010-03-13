require 'fileutils'

task :default => :test

task :clean do
  files=Dir["**/*~"]
  puts "Removing #{files.size} Emacs temp file#{(files.size==1?'':'s')}"
  files.each do |tmp|
    FileUtils.rm tmp
  end

  puts "Removing built gem"
  `rm -f *.gem`
end

task :test do
  exec "spec --color test/*.rb"
end

task :gem do
  `rm -f groundwork-*.gem`
  `gem build groundwork.gemspec`
end

task :install=>:gem do
  `gem install --force groundwork-*.gem`
end

task :bump do
    new_version = ENV["VERSION"] ? ENV["VERSION"] : File.read("VERSION").succ
    File.open("VERSION","w") do |f|
        f.print new_version
    end

    puts "Bumped version to #{new_version}"
end
