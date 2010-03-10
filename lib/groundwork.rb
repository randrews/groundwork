require "rubygems"
require "trollop"
require "erb"
require "pathname"
require File.join(File.dirname(__FILE__), "options.rb")
require File.join(File.dirname(__FILE__), "tar_wrapper.rb")
require File.join(File.dirname(__FILE__), "recipe.rb")
require File.join(File.dirname(__FILE__), "recipe_class.rb")
require File.join(File.dirname(__FILE__), "recipe_unpacker.rb")

module Groundwork

  # Return a hash of all known recipes, the included ones and the ones in .groundwork
  def self.known_recipes
    recipes = {}
    Dir[File.join(File.dirname(__FILE__),"..","recipes","*.recipe")].each do |recipe|
      recipes[File.basename(recipe,".recipe")] = recipe
    end

    dot_groundwork = File.expand_path("~/.groundwork")

    if File.directory?(dot_groundwork)
      Dir[File.join(dot_groundwork,"*.recipe")].each do |recipe|
        recipes[File.basename(recipe,".recipe")] = recipe
      end
    end

    recipes
  end
end
