$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'dependo'
require 'redis'
require 'json'
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
		@activity = activity
	end

	def save_to_activity_streams
		# Save to each friends activity stream
		@friends.each do |friend_id|
			puts "#{friend_id}"
			save_to_activity_stream "newsfeed:#{friend_id}", MAX_LENGTH_TIMELINE
		end

		# Save to user activity stream
		actor = @activity[:actor.to_s]
		puts "#{actor}"
		actor_id = actor[:actorId.to_s] unless actor.nil?
		puts "Actor = #{actor_id}"
		save_to_activity_stream "timeline:#{actor_id}" 
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