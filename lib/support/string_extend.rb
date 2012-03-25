#This helper is opening up core Ruby String
#classes to add a new method call to all strings

class String

	def titleize
		self.split(' ').collect {|word| word.capitalize}.join(" ")
	end
end