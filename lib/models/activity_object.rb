$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'models/json_serializer'

class ActivityObject
	include JSONSerializer

	attr_accessor :image, :url, :id, :content

	def initialize
		@content = ""
		@url = ""
		@id = 0
		@image = {}
	end
end