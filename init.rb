require 'sinatra'
require 'fileutils'


#FileUtils.copy('file_app.rb', 'food_lover/file_app.rb')
#Dir.mkdir("lib")
#print File.dirname(__FILE__)
APP_ROOT = File.dirname(__FILE__)
# require "#{APP_ROOT"}/lib/guide
# require File.join(APP_ROOT, 'lib', 'guide.rb')
# require File.join(APP_ROOT, 'lib', 'guide')

$:.unshift( File.join(APP_ROOT, 'lib') )
require 'guide'
#require File.join(APP_ROOT, 'support', 'number_helper')
#$:.unshift( File.join(APP_ROOT, 'support') )
#require 'number_helper'

guide = Guide.new('restaurants.txt')
guide.launch!