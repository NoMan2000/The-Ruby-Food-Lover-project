require 'restaurant'
require 'support/string_extend'
class Guide

	class Config
		@@actions = ['list', 'find', 'add', 'quit']
		def self.actions
			@@actions
		end
		#semi-colons will break the method just like
		#new lines.  This is a reader method to allow
		#access outside the class
	end


	def initialize(path=nil)
	#locate the restaurant text file
		Restaurant.filepath = path
		if Restaurant.file_usable?
			puts "Found restaurant file."
		#or create a new file
		elsif Restaurant.create_file
			puts "Created restaurant file."
		else 
			puts "Exiting. \n\n"
			exit!
			# This is a special command that immediately exits.
		end
	end

	#exit if create fails

	def launch!
		introduction
		action_loop
		#what do you want to do? (list, find, add, quit)
		#do that action
		#repeat until user quits
		conclusion
	end

	def introduction
		puts "\n\n <<< Welcome to the local restaurant food finder! >>> \n\n"
		puts "This is a quick command-line application to help you find the food you crave\n"
	end

	def conclusion
		puts "\n Goodbye and hope you found what you were looking for!\n"
	end

	def action_loop
		result = nil
		until result == :quit
			action, args = get_action
			result = do_action(action, args)
		end
	end

	def get_action
		action = nil
		# Keep asking for user input
		until Guide::Config.actions.include?(action)
			puts "Actions: " + Guide::Config.actions.join(", ") if action
			print "> "
			user_response = gets.chomp
			args = action = user_response.downcase.strip.split(' ')
			action = args.shift
		end
		return action, args #this is an array
	end

	
	def do_action(action, args=[])
		case action
		when 'list'
			list(args)
		when 'find'
			keyword = args.shift
			find(keyword)
		when 'add'
			add
		when 'quit'
			return :quit
		else
			puts "\nI do not understand that command."
		end
	end

	def add
		output_action_header("Add a new Restaurant")
		restaurant = Restaurant.build_using_questions
		if restaurant.save
			puts "\nRestaurant added!\n\n"
		else
			puts "\nSave Error:  Restaurant not added???\n"
		end
	end

	def list(args=[])
		sort_order = args.shift 
		#sort_order ||= "name" #default value handled below
		sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)
		output_action_header("List of Restaurants")
		restaurants = Restaurant.saved_restaurants
		restaurants.sort! do |r1, r2|
			case sort_order
			when 'name'
				r1.name.downcase <=> r2.name.downcase
			when 'cuisine'
				r1.cuisine.downcase <=> r2.cuisine.downcase
			when 'price'
				r1.price.to_i <=> r2.price.to_i
			end
		end
		output_restaurant_table(restaurants)
		puts "Sort using: 'list cuisine', 'list price', or 'list name'\n\n"
	end
	
	def find(keyword="")
		output_action_header("Find a particular restaurant")
		if keyword
			restaurants = Restaurant.saved_restaurants
			found = restaurants.select do |rest|
				rest.name.downcase.include?(keyword.downcase) ||
				rest.cuisine.downcase.include?(keyword.downcase) ||
				rest.price.to_i <= keyword.to_i
			end	
			output_restaurant_table(found)
			#search
		else
			puts "Find using a keyword to search the list"
			puts "Examples: 'find tamale', 'find Mexican', 'find mex'\n\n"
		end
	end 

	private
	def output_action_header(text)
		puts "\n#{text.upcase.center(60)}\n\n"
	end

	def output_restaurant_table(restaurants=[])
	print " " + "Name".ljust(30)
	print " " + "Cuisine".ljust(20)
	print " " + "Price".rjust(6) + "\n"
	puts "-" * 60
	restaurants.each do |rest|
		line = " " << rest.name.titleize.ljust(30)
		line << " " + rest.cuisine.titleize.ljust(20)
		line << " " + rest.formatted_price.rjust(6)
		puts line
		end
	puts "No listings found" if restaurants.empty?
	puts "-" * 60
	end
end