$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'models/activity'
require 'dependo'
require 'logger'

class ActivityPresenter
	include Dependo::Mixin

	def initialize(logger)
		@logger = logger
	end

	def present(hash)
		key = "#{hash[:type].to_s}:#{hash[:user_id]}"
		@logger.info "#{key}, #{hash[:start]}, #{hash[:stop]}"
		activities = activity_db.lrange key, hash[:start], hash[:stop]
		total_records = activity_db.llen key

		result = { 	"total" => total_records, 
								"start" => hash[:start],
								"stop" => hash[:start] + activities.length - 1,
								"activities" => activities
								 }
	end
end

