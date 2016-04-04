ENV["RACK_ENV"] ||= 'development'

require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
# require "pry"
require_relative "lib/adventure" # database.rb should be inherited from adventure which requires it
  # ActiveRecord::NoDatabaseError: FATAL:  database "create_your_own_adventure_test" does not exist

helpers do
  def current_user
      User.where(token: request.env["HTTP_AUTHORIZATION"]).first  #"HTTP_X_TACO_TOKEN"
  end

  def authenticated
    halt 401, {msg: "go away!"}.to_json unless current_user
  end

  def current_session
    Adventure::Session.where(token: request.env["HTTP_AUTHORIZATION"]).first
  end

end

set :static, true
set :public_folder, Proc.new { File.join(root, "..", "client") }

before do
  content_type "application/json"
end

# get "/backend" do
#   "I am Groot!"
# end
#
# post "/backend/echo" do
#   payload = JSON.parse(request.body.read)
#   payload.to_json
# end
#
# get "/backend/steps" do
#   Step.all.to_json
# end
#
# get "/backend" do
#   "Ryan needs a POST"
# end

# Build request
# request = Net::HTTP::Patch.new(uri.request_uri, update)
# request.body = JSON.generate update
# request.basic_auth(username, password)
# # Perform request
# response = http.request(request)


post "/" do
  payload = JSON.parse(request.body.read)
  payload.to_json
end

post '/login' do                                  # does this work for Ryan's login button
  # unless params["login"] == "magicadventure"
  #   halt 403, 'no adventure today'
  # end
  token = SecureRandom.hex
  User.create(token: token)
  {token: token}.to_json
end

post '/user' do   # i need to give ryan the auth token in the header
  user = User.where(token: request.env["HTTP_AUTHORIZATION"]).first
  halt 403, 'no adventure today' unless user
  adventure = Adventure::Adventure  #<--Adventure is the module, like TacoTweet
  [200, adventure.to_json]
end

# need to be able to store which token we've given to whom
# User.find() # save the token on that user
# User.create(token: token)
# User.where(token:


get '/storyname' do
  # halt_unless_user
  story = Story.all
  [200, story.to_json]
end

###########
# after you have added your authentication and are trying to write tests for your subsequent `POST` requests.
# Your `post` requests will now need to have the authentication token passed into them so that can do their things.
# You can trace back above to see how to add headers to your mock requests. But the key things to remember is that
# when you do the `header()`, ​_don’t_​ include prepend your header name with `HTTP_` - meaning,
# use `header("AUTHORIZATION", value)` and not `header("HTTP_AUTHORIZATION", value)`. This is because Rack adds
# the `HTTP_` part for you.
###########

#1 Create a new Story record with a title   # Ryan needs an object(hash) with the name of the story and an id for the story
  # backend sends id of story just created
post '/story' do     # 500 server error for POSTs?
  story = Story.create(:name)   # Story title
  payload = JSON.parse(request.body.read)
  Story.create(payload).to_json
end

#2 Read a Story to json
  # front end sends api requests to backend
get '/storyread' do       # 400 Bad Request; for invalid user input?
  # story_id.read.to_json  reading a story
end

#3 Update a Story record
patch '/storyupdate/' do   # 500 like for POSTs
  # story_id update partial
  payload = JSON.parse(request.body.read)
  # adventure = Adventure.find(params["id"]).update(payload).to_json
  story = Story.find(params["name"]).update(payload).to_json
end
# Update a user's adventure
patch "/story/:id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first
  unless user == nil
    payload = JSON.parse(request.body.read)
    story = Adventure::Story.find(params["id"]).update(payload).to_json
  else
     halt 401, {msg: "Unauthorized"}.to_json
  end
end


#4 Destroy a Story record
delete "/story_delete/:id" do       # 303 See Other (since HTTP/1.1). The response to the request can be found under another URI using a GET method. When received in response to a POST (or PUT/DELETE), the client should presume that the server has received the data and should issue a redirect with a separate GET message.[28]
  story = Story.find(:id)
  story.id.destroy!
end

#5 Create a Step in a story which has the following properties:
# whether or not this step is the start of the story
# story text (for this step)
# text for option one
# step id to go to if option one is selected
# text for option two
# step id to go to if option two is selected
# whether or not this is a last step in that path (in which case there are NO options)
# if step == initial step  # do something special, but what?
# else                     # do the normal thing
# until step == last_step  # does until mean it implicitely ends when this isn't true?
#   step.create(text_initial, text_option_1, step_id_option_1, text_option_2, step_id_option_2)
# post '/newstory' do
#   # some sort of conditional ?
#   "story text"
# end
#   "option one story text"
# get '/optionone' do
# end
#   "option two story text"
# get '/optiontwo' do
# end
  # some sort of conditional or else end

# 405 Method Not Allowed. A request method is not supported for the requested resource; for example, a GET request on a form which requires data to be presented via POST, or a PUT request on a read-only resource.

# Ryan needs the name of the step
 # stepname
 # data.optiona
 # data.optionb

# 6 Read a Step to JSON
post '/step/:id' do
  payload = JSON.parse(request.body.read)
  step = Step.create(payload)
  step.to_json
end
#
#7 Update a Step record
patch '/step/:id' do
  # step_id  partial update
  payload = JSON.parse(request.body.read)
  step = Step.find(params["id"])
  step.update(payload)
  step.to_json
end

# 8 Destroy a Step record
delete '/step_deletion/:id' do  # or delete “/step_del/#{step.id}" ?
  # delete step record from db
  step = Adventure::Step.find(params["id"])
  step.destory!
  # payload = JSON.parse(request.body.read)
  # step_record = Step.find(params["id"]).update(payload)
  # step_record.to_json
end

#
#9 Read next Step, for a given Step, if one is present
get '/next_step/:step_id'
  # step_id.read   conditional until?
  # looks up next corresponding step in the db
end
