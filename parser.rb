
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
		file.each_line {
			|line| puts line.reverse
			puts line
			arg[0] = line[0]
			arg[1] = line[1]
		}
	end
end

