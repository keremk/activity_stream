$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'workers/activity_writer'
require 'rspec'
require 'rack/test'
require 'factory_girl'

describe ActivityWriter, 'ActivityWriter test' do 
	before(:each) do
		@activity = Activity.new 
	end
  it "creates a new Activity worker from activity" do 
  	activity = 
  	activity_writer = ActivityWriter.new 
  end 
end