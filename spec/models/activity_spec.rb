$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'models/activity'
require 'rspec'
require 'rack/test'

describe Activity, 'ActivityWriter test' do 
	# @load_path = File.expand_path(File.dirname(__FILE__) + '/../factories/')
	it "creates correct Activity from JSON" do		
	end

	it "serializes to correct JSON from Activity" do
	end

	it "validates to correct schema from JSON" do 

	end
end
