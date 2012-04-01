require 'Time'

# Read in a file
def read_file(file_name="")
	File.open(file_name) do |file|
		while line = file.gets
			a = %w{#{line}}
			puts a
			puts line
		end
	end
end

def parse(file_name, arg, position)
	#remove comment
  begin
    File.open(file_name) do |file|
      file.each_with_index do |line, index|
        next if index < 3
        word = line.split
        arg[index-3] = word[position]
      end
    end
  rescue => err
    puts "Exception: #{err}"
    err
  end
end

arg = []
parse("call_arrival_g04.txt", arg, 1)
puts arg.inspect
arg.each_with_index {|element, index| arg[index] = Time.parse(element)}
puts arg.inspect
