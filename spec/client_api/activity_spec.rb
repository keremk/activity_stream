$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../')
require 'client_api/activity'
require 'client_api/activity_description'
require 'spec/factories/activities'

describe Activity, "Activity test" do 
	before(:each) do
		# User and Game will come from GG
		@mock_user = MockUser.make
		@mock_game = MockGame.make
		@activity_description = ActivityDescription.new :content => "10203"
	end

	it "should translate user to the standard actor in Activity JSON spec" do 
		activity = Activity.new :activity_code => "1001", :user => @mock_user, :activity_description => @activity_description
		activity.actor[:actorId].should_not == nil
		activity.actor[:displayName].should == "JohnDoe"
		activity.actor[:image][:url].should == "http:://localhost:5000/pictures/users/johndoe.png"
		activity.title.should == "JohnDoe has a new highscore 10203 in "
	end

	it "should translate game to the standard target in Activity JSON spec" do
		activity = Activity.new :activity_code => "1001", :user => @mock_user, :game => @mock_game, :activity_description => @activity_description
		activity.target[:id].should_not == nil
		activity.target[:displayName].should == "BladeSlinger"
		activity.target[:image][:url].should == "http:://localhost:5000/pictures/games/bladeslinger.png"
		activity.title.should == "JohnDoe has a new highscore 10203 in BladeSlinger"
	end

	it "should still accept games with no image url" do
		@mock_game.image = nil
		activity = Activity.new :activity_code => "1001", :user => @mock_user, :game => @mock_game, :activity_description => @activity_description
		activity.should_not == nil 
		activity.target[:id].should_not == nil
	end

	it "should raise exception when no user provided" do
		lambda { Activity.new :activity_code => "1001"}.should raise_error(ArgumentError)
	end

	it "should raise exception when user has no id" do
		@mock_user.id = nil
		lambda { Activity.new :activity_code => "1001", :user => @mock_user}.should raise_error(ArgumentError)		
	end

	it "should have a valid verb for the activity code" do
		activity = Activity.new :activity_code => "1001", :user => @mock_user, :activity_description => @activity_description
		activity.verb.should == "score update"
	end

	it "should have a valid published date for the activity code" do
		activity = Activity.new :activity_code => "1001", :user => @mock_user, :activity_description => @activity_description
		activity.published.should_not == nil
	end
end
