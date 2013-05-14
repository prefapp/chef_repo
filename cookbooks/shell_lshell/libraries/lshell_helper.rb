module LshellHelper
	def join_files(path)
	  res = ''

	  Dir.entries(path).each do |file|
	    next if file =~ /^\.+$/
	    res << IO.read("#{path}/#{file}")
	    res << "\n"
	  end
	  
	  res

	end
end