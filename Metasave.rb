#! /usr/bin/ruby
require "digest/sha1"
require "csv"
filenames = `mdfind -0 -onlyin . "kMDItemWhereFroms == *"`.split(/\0/)

filenames.each do |filename|
  metad = `mdls -name kMDItemWhereFroms \"#{filename}\"`
  puts Digest::SHA1.file(filename).hexdigest
  sources = metad.scan(/["][^"]*["]/)
  printf "%s,%s,%s\n", filename, sources[0], sources[1]
end

