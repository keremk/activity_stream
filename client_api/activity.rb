# Example activities:
#
# John has a new highscore 1000 in Bladeslinger
# John now ranks 1st in Bladeslinger
# John achieved "Fast Trigger" in Bladeslinger
# Mary started playing Bladeslinger
# Mary rated Bladeslinger 5 stars
# Mary joined GorillaGraph
# John posted "Hey you did you great" in Bladeslinger
# John completed the "Ride a horse" challenge in Bladeslinger
# Mary now has a total score of 10000
# Mary ranks Pro 
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../')

require 'date'
require 'client_api/activity_description'
require 'lib/models/json_serializer'

# This is based on JSON Activity Streams Spec http://activitystrea.ms/specs/json/1.0/
# 
class Activity
	include JSONSerializer
	attr_accessor :published, :actor, :title, :verb, :object, :target
	attr_reader :friends

	def initialize(hash)
		@activity_code = hash[:activity_code] 
		raise ArgumentError.new('Not valid activity code') if @activity_code.nil? && (@activity_code.to_i < 0 && @activity_code.to_i > 2)
		to_standard_activity hash
	end

private

	VERB_DEFINITIONS = {
		"1001" => "score update",
		"1002" => "rank",
		"1003" => "achieve"
	}

	# Following mapping is used:
	# user -> actor
	# target -> game
	# verb -> verb
	# activity_description -> object
	def to_standard_activity(hash)
		@actor = actor_definition hash
		@target = target_definition hash
		@object = activity_object_definition hash
		@title = title_definition
		@verb = VERB_DEFINITIONS[@activity_code]
		@published = DateTime.now
	end

	def actor_definition(hash)
		user = hash[:user]
		raise ArgumentError.new('User is required for activity') if user.nil?
		raise ArgumentError.new('User needs an id') if user.id.nil?

		@friends = user.friends || []

		actor = {}
		actor[:actorId] = user.id
		actor[:displayName] = user.display_name || 'Unknown'
		image_url = user.picture_url || ''
		actor[:image] = { :url => image_url }
		actor[:objectType] = 'person'
		actor[:url] = ''
		actor
	end

	def target_definition(hash)
		game = hash[:game]

		target = {}
		target[:objectType] = 'game'
		return target if game.nil?

		target[:id] = game.id || ''
		target[:displayName] = game.name || ''
		image_url = game.image || ''
		target[:image] = { :url => image_url }
		target[:url] = ''
		target
	end

	def activity_object_definition(hash)
		activity_description = hash[:activity_description]

		object = {}
		return object if activity_description.nil?

		object[:content] = activity_description.content
		image_url = activity_description.image || ''
		object[:image] = { :url => image_url }
		object
	end


	def title_definition
		actor_name = @actor[:displayName]
		content = @object[:content]
		target_display_name = @target[:displayName]

		# TODO: Make title_definitions a constant and templatize it instead of defining inline
		title_definitions = { 
				"1001" => "#{@actor[:displayName]} has a new highscore #{@object[:content]} in #{@target[:displayName]}",
				"1002" => "#{@actor[:displayName]} now ranks #{@object[:content]} in #{@target[:displayName]}",
				"1003" => "#{@actor[:displayName]} achieved #{@object[:content]} in #{@target[:displayName]}" }

		title = title_definitions[@activity_code]
	end
end
