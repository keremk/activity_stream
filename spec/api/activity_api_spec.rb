$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'api/activity_api'
require 'rspec'
require 'rack/test'

describe 'HelloWorld Test' do 
  def app
    ActivityAPI
  end
  
  it "says Hello World" do 
    get '/'
    last_response.should be_ok
    last_response.body.should == "Hello World"
  end 
end