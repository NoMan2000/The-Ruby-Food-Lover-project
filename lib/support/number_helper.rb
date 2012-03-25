=begin
This module i ho included or mixed in class can be 
used and reused.  It borrows from the Ruby on Rails
number_to_currency method, which rock.
=end

module NumberHelper

	def number_to_currency(number, options={})
		unit = options[:unit] || '$'
		precision = options[:precision] || 2
		delimiter = options[:delimiter] || ','
		separator = options[:separator] || '.'

		separator '' if precision == 0
		integer, decimal = number.to_s.split('.')

		i = integer.length
		until i <= 3
			i -= 3
			integer = integer.insert(i, delimiter)
		end

		if precision == 0
			precise_decimal = ''
		else
			#make sure decimal is not nil
			decimal ||= "0"
			#make sure it's not too large
			decimal = decimal[0, precision-1]
			#make sure it's not too small 
			precise_decimal = decimal.ljust(precision, "0")
		#"Hello".ljust(30, "*") # places 30 asterixx
		#"Hello".rjust(30, "*") # right justifies and fills 30 spaces
		#"Hello".rjust(30) # moves it with 30 blank spaces, very nice.
		#"Hello".center(30) #centers it w/ 30 char

		end

		return unit + integer + separator + precise_decimal
	end
end