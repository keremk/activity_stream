$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'models/actor'
require 'models/activity_object'
require 'models/target'
require 'models/json_serializer'

# Example Activities:
# 	John scored 1500 in Bladeslinger
# => actor: John
# => verb: score
# => object: 1500 (high score)
# => target: Bladeslinger (game)

class Activity
	include JSONSerializer
	attr_accessor :actor, :verb, :target, :activity_object, :publish_date, :summary

	def initialize
		@actor = nil
		@verb = ""
		@target = nil
		@activity_object = nil
		@publish_date = Date::today
		@summary = ""
	end

end