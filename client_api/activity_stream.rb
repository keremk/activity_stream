$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../client_api')

require 'httparty'
require 'activity'

class ActivityStream
	include HTTParty
	base_uri 'http://localhost:5000'

	def initialize()
	end

	def post_activity(activity)
		raise ArgumentError.new("Need an actor defined") if activity.actor.nil?
		user_id = activity.actor[:actorId]
		raise ArgumentError.new("Need a valid actor for the activity") if user_id.nil?
		
		options = { :headers => { 'Content-Type' => 'application/json' }, :body => activity.to_json }
		response = self.class.post("/v1/users/#{user_id}/activity", options)
		response
	end
end
