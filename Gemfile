source :rubygems

gem "thin"
gem "sinatra"
gem "sinatra-contrib"
gem "foreman"
gem "rake"
gem "dependo", :git => 'git://github.com/sirsean/dependo.git'
gem "activesupport"

# Database
gem "resque", "~> 1.22.0"
gem "sinatra-redis"

group :development, :test do
	gem "pry"
	gem "debugger"
	gem "rerun"
	gem "rb-fsevent", "~> 0.9.1"
end

group :test do
  gem "simplecov"
  gem "rspec"
  gem "rack-test"
end

group :production do

end
