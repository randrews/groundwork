require "rubygems"
require "archive/tar/minitar"
require "base64"

class Groundwork::TarWrapper
  include Archive::Tar

  # Takes a base64-encoded, tarred string
  def initialize encoded
    tar = Base64.decode64(encoded)
    @files = {}
    Minitar::Reader.new(StringIO.new(tar)).each do |entry|
      next unless entry.file?
      @files[entry.full_name] = entry.read
    end
  end

  def [] name
    @files[name]
  end

  def self.compress files
    string = StringIO.new
    output = Minitar::Output.new(string)

    files.each do |file|
      Minitar.pack_file(file, output)
    end

    output.close
    Base64.encode64 string.string
  end
end
