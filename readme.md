# Setup
This requires Ruby 1.9.3 or higher. You would also need Redis installed on your machine.

To install:

$ gem install bundler
$ bundle install

Once installed, run:

$ redis-server 

and then you can start the services by:

$ RACK_ENV=development foreman start

# Test

Please keep the server running (This will change in a later version), because there is a client ruby
api involved and it is in the same rspec list.

Then run the tests by

$ bundle exec rspec .

