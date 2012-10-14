require 'redis'
require 'resque'
require 'dependo'

activity_db = Redis.new :url => 'redis://localhost:6379'
# TODO: Should we be adding namespace support through redis-namespace 
# http://dev.af83.com/2012/07/31/should-we-namespace-redis.html
Dependo::Registry[:activity_db] = activity_db

Resque.redis = Redis.new :url => ENV['REDISTOGO_URL']
# Resque.redis.namespace = "resque:incoming"
