$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'bundler/setup'
Bundler.require(:default)
require 'sinatra/base'
require 'sinatra/redis'

require 'presenters/activity_presenter'
require 'workers/activity_writer'

class ActivityAPI < Sinatra::Base
	include Dependo::Mixin	

	ACTIVITY_WHITELIST = [:published, :actor, :verb, :summary, :object, :target]

	configure do
		enable :logging
	end

	get '/' do
		"hello world"
	end

	post '/v1/users/:user_id/activity' do 
		begin
			incoming_message = JSON.parse(request.body.read.to_s)
			logger.info "#{incoming_message}"

			activity = {}
			ACTIVITY_WHITELIST.each do |key|
				activity[key.to_s] = incoming_message[key.to_s]
			end
			logger.info "#{activity}"

			friends = incoming_message[:friends.to_s] || []
			logger.info "#{friends}" 
			
			Resque.enqueue(ActivityWriter, activity, friends)
			logger.info "Item queued up"
			
			[200, "Successfully posted to queue"]
		rescue JSON::ParserError => e
			logger.info "Error: #{request.body.read}"
			logger.info "Error: #{e.message}, Backtrace: #{e.backtrace}"
			[400, "Malformed JSON post"]
		end
	end

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
			activities = presenter.present :start => start, :stop => stop, :type => stream_type, :user_id => user_id		
			logger.info "#{activities}"
			[200, activities]
		end
	end

end
