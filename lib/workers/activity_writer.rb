$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'dependo'
require 'redis'
require 'json'
require 'models/activity'
require 'resque'

class ActivityWriter
	include Dependo::Mixin
	MAX_LENGTH_TIMELINE = 1000
	@queue = :default

	def self.perform(activity, friends)
		(new(activity, friends)).save_to_activity_streams
	end

	def initialize(activity, friends)
		@friends = friends || []
		@activity = Activity.new
		@activity.from_hash(activity)

		check_key = Dependo::Registry.has_key?(:test2)
	end

	def save_to_activity_streams
		# Save to each friends activity stream
		@friends.each do |friend_id|
			save_to_activity_stream "news:#{friend_id}", MAX_LENGTH_TIMELINE
		end

		# Save to user activity stream
		save_to_activity_stream "timeline:#{@activity.actor.actor_id}"
	end

	def save_to_activity_stream(key, limit=-1)
		activity_json = @activity.to_json	

		activity_db.lpush key, activity_json
		list_size = activity_db.llen key
		if (list_size > limit && limit != -1)
			# remove the oldest activity
			activity_db.rpop key 
		end
	end
end