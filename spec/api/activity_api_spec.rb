$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../')
require 'lib/api/activity_api'
require 'rspec'
require 'rack/test'
require 'spec/factories/activities'
require 'client_api/activity_stream'

describe 'Activity API get activities test' do 
	include Rack::Test::Methods

  def app
    ActivityAPI
  end
  
  before(:each) do
  	# TODO: Cleanup Redis database
  	15.times do |i|
  		user_id = Random.rand(1...4)
  		mock_user = MockUser.make :id => "1000#{user_id}"
			mock_game = MockGame.make
			activity_description = [ ActivityDescription.new(:content => Random.rand(1000...5000).to_s),
						ActivityDescription.new(:content => Random.rand(1...5).to_s),
						ActivityDescription.new(:content => 'Fast Trigger', :image => 'http:://localhost:5000/pictures/achievements/bladeslinger.png')
					]

			activity_code = Random.rand(1...3)			
			activity = Activity.new(:activity_code => "100#{activity_code}", 
							:user => mock_user, :game => mock_game, 
							:activity_description => activity_description[activity_code])
  		activity_stream = ActivityStream.new
  		activity_stream.post_activity activity
  	end
  	# wait for the queue workers to pick up
  	# TODO: find a better way!
  	sleep(5)
  end

  it "says Hello World" do 
    get '/'
    last_response.should be_ok
    last_response.body.should == "Hello World"
  end 

  it "should return last activities in a user's timeline" do
  	get '/v1/users/10001/timeline'
  	response_hash = JSON.parse(last_response.body)
  	response_hash["activities"].each do |item|
  		item["actor"]["objectType"].should == "person"
  	end
  	last_response.should be_ok

  end

  it "should return last activities in a user's friends' timeline" do
  	get '/v1/users/10001/newsfeed'
  	response_hash = JSON.parse(last_response.body)
  	response_hash["activities"].each do |item|
  		item["actor"]["objectType"].should == "person"
  	end

  	last_response.should be_ok
  end
end