require_relative 'parser'

read_file "test.txt"
parse "test.txt" id duration
puts id."\n".duration