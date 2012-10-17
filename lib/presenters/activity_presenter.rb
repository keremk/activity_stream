$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'models/activity'
require 'dependo'
require 'logger'
require 'redis'

class ActivityPresenter
	include Dependo::Mixin

	def initialize()
	end

	def present(hash)
		key = "#{hash[:type].to_s}:#{hash[:user_id]}"
		log.info "#{key}, #{hash[:start]}, #{hash[:stop]}"
		
		new_list = []
		activities = activity_db.lrange key, hash[:start], hash[:stop]
		activities.each do |activity_json|
			activity = JSON.parse(activity_json)
			new_list << activity
		end
		stop = (activities.length == 0) ? 0 : activities.length - 1

		total_records = activity_db.llen key
		result = {  "total" => total_records, 
								"start" => hash[:start],
								"stop" => stop,
								"activities" => new_list }
	end
end

