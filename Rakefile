$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'bundler/setup'
Bundler.require(:default)
require './config/config'

require 'resque/tasks'
require 'lib/workers/activity_writer'

task "resque:setup" do
	ENV['QUEUE'] = 'default'
end

task :start do
	exec "rackup config.ru"
end
# task "jobs:work" => "resque:work"