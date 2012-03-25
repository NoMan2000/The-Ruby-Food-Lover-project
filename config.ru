APP_ROOT = File.dirname(__FILE__)

$:.unshift( File.join(APP_ROOT, 'lib') )
require 'greeter'
use Rack::Reloader, 0

run Greeter