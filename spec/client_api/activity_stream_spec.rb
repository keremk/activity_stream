$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../')
require 'client_api/activity'
require 'client_api/activity_description'
require 'client_api/activity_stream'
require 'spec/factories/activities'

describe ActivityStream, "Activity Stream test" do 
	before(:each) do
		@mock_user = MockUser.make
		@mock_game = MockGame.make
		@activity_description = ActivityDescription.new :content => "10203"
		@activity = Activity.new :activity_code => "1001", :user => @mock_user, :game => @mock_game, :activity_description => @activity_description
	end

	it "should raise an error if user is not specified" do 
		activity_stream = ActivityStream.new
		@activity.actor = nil
		lambda { activity_stream.post_activity(@activity)}.should raise_error(ArgumentError)		
	end

	it "should post an activity to ActivityStream service" do
		activity_stream = ActivityStream.new
		response = activity_stream.post_activity @activity
		response.success?.should be_true
	end
end