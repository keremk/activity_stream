$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'workers/activity_writer'
require 'rspec'
require 'rack/test'

describe ActivityWriter, 'ActivityWriter test' do 
	before(:each) do
	end
  it "creates a new Activity worker from activity" do 
  end 
end