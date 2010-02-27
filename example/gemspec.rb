require "rubygems"
 
SPEC=Gem::Specification.new do |s|
  s.name = "<%=@name%>"
  s.version = File.read(File.join(File.dirname(__FILE__), "VERSION"))
  s.date = ""
  s.author = "Your Name"
  s.email = "Your Email"
  s.homepage = "http://example.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "Short summary"
  s.description = <<-STR
Longer project description
STR

  s.rubyforge_project="<%=@name%>"

  s.files = ["VERSION"] + Dir["lib/**/*.rb"]
  s.executables=["<%=@name%>"]
  s.has_rdoc=false
 
  # s.add_dependency("whatever",">= 1.0.0")
end
