$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'models/json_serializer'

class Actor
	include JSONSerializer
	attr_accessor :actor_id, :attributes, :image, :display_name

	def initialize
		@actor_id = 0
		@image = nil
		@display_name = ""
	end

end