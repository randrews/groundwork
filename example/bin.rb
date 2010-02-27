#!/usr/bin/ruby

require File.join(File.dirname(__FILE__),"..","lib","<%= @name %>.rb")

begin
    raise RuntimeError.new("Not implemented yet; edit bin/<%=@name%>")
rescue
    puts $!.to_s
end
