require 'machinist'

class MockGame
	extend Machinist::Machinable
	attr_accessor :name, :id, :image
end

class MockUser
	extend Machinist::Machinable
	attr_accessor :id, :display_name, :picture_url, :friends
end

MockUser.blueprint do
	id { "100#{sn}" }
	display_name { "JohnDoe" }
	picture_url { "http:://localhost:5000/pictures/users/johndoe.png"}
	friends {[]}
end

MockGame.blueprint do
	id { "1000#{sn}" }
	name { "BladeSlinger"}
	image { "http:://localhost:5000/pictures/games/bladeslinger.png"}
end

