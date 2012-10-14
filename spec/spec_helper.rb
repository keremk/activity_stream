$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'simplecov'
require 'rspec'
require 'rack/test'
require 'api/activity_api'

SimpleCov.start do
  add_filter "/spec/"
end 

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    ActivityAPI
  end
end
