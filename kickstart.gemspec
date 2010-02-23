require 'rubygems'
 
SPEC=Gem::Specification.new do |s|
  s.name='kickstart'
  s.version='0.0.1'
  s.date='2010-02-23'
  s.author='Andrews, Ross'
  s.email='randrews@geekfu.org'
  s.homepage='http://geekfu.org'
  s.platform=Gem::Platform::RUBY
  s.summary="A project scaffolding generator"
 
  s.files=["kickstart.rb", "tar_wrapper.rb"]
  s.executables=["kickstart"]
  s.has_rdoc=false
 
  s.add_dependency("trollop",">= 1.10.2")
  s.add_dependency("archive-tar-minitar",">= 0.5.2")
end