
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

def parse(file_name="", arg)
	#remove comment
	File.open(file_name) do |file|
		file.each_line do |line|
      arg = line.split
      puts arg
    end
	end
end
a = 1
b = 2
c = 3
parse("test.txt", [a, b, c])
puts a, b, c
