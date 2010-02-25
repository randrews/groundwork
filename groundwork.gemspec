require "rubygems"
 
SPEC=Gem::Specification.new do |s|
  s.name="groundwork"
  s.version = File.read(File.join(File.dirname(__FILE__), "VERSION"))
  s.date='2010-02-23'
  s.author='Andrews, Ross'
  s.email='randrews@geekfu.org'
  s.homepage="https://github.com/randrews/groundwork"
  s.platform=Gem::Platform::RUBY
  s.summary="A project scaffolding generator"
  s.description="Create scripts that describe the groundwork for laying out your projects, and generate project frameworks"
  s.rubyforge_project="groundwork" 

  s.files = ["VERSION"] + Dir["lib/**/*.rb"] + Dir["commands/**/*.rb"] + Dir["recipes/**/*.recipe"]
  s.executables=["groundwork"]
  s.has_rdoc=false
 
  s.add_dependency("trollop",">= 1.10.2")
  s.add_dependency("archive-tar-minitar",">= 0.5.2")
end
