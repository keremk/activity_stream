$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'models/json_serializer'

class Target
	include JSONSerializer
	attr_accessor :url, :object_type, :id, :display_name

	def initialize
		@url = ""
		@object_type = ""
		@id = 0
		@display_name = ""
	end
end