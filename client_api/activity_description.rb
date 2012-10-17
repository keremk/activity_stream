class ActivityDescription
	attr_accessor :content, :image

	def initialize(hash)
		@content = hash[:content] || ""
		@image = hash[:image] || ""
	end
end
