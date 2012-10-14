require './lib/api/activity_api'
require 'resque/server'
require 'logger'

use Rack::ShowExceptions

if ENV['RACK_ENV'] == 'development'
	ENV['REDISTOGO_URL'] ||= 'redis://localhost:6379'
end

require './config/config'

run Rack::URLMap.new \
	"/" => ActivityAPI,
	"/resque" => Resque::Server.new

