$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'bundler/setup'
Bundler.require(:default)
require 'sinatra/base'
require 'sinatra/redis'

require 'models/activity'
require 'presenters/activity_presenter'
require 'workers/activity_writer'

class ActivityAPI < Sinatra::Base
	include Dependo::Mixin	
	configure do
		enable :logging
		
		# uri = URI.parse('redis://localhost:6379')
		# Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
		# Resque.redis.namespace = "resque:incoming"
		# set :redis, ENV["REDISTOGO_URL"]
	end

	get '/' do
		"hello world"
	end

	post '/v1/users/:user_id/activity' do 
		begin
			incoming_message = request.body.read.to_s
			logger.info("#{incoming_message}")
			activity = Activity.new
			activity.from_json(incoming_message)
			friends = incoming_message[:friends.to_s] || [] 
			Resque.enqueue(ActivityWriter, activity, friends)
			logger.info "Item queued up"
			[200, ""]
		rescue JSON::ParserError => e
			logger.info "Error: #{e.message}, Backtrace: #{e.backtrace}"
		end
	end

	#Polk94109$
	# user_id = 0 is global
	# :stream_type is news or timeline
	get '/v1/users/:user_id/:stream_type' do
		begin
			stream_type = params[:stream_type]
			logger.info stream_type
			return [404, "Invalid stream type"] if (stream_type != :timeline.to_s) && (stream_type != :newsfeed.to_s)

			start = params[:start] || 0
			stop = params[:stop] || 100
			user_id = params[:user_id] || 0

			presenter = ActivityPresenter.new logger
			newsfeed = presenter.present :start => start, :stop => stop, :type => stream_type, :user_id => user_id		
			logger.info "#{newsfeed}"
			[200, newsfeed]
		end
	end

end
