ENV["RACK_ENV"] ||= 'development'

require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"

require_relative "lib/adventure" # database.rb should be inherited from adventure which requires it
  # ActiveRecord::NoDatabaseError: FATAL:  database "create_your_own_adventure_test" does not exist

helpers do
  def current_user
      User.where(token: request.env["HTTP_AUTHORIZATION"]).first  #"HTTP_X_TACO_TOKEN"
  end

  def authenticated
    halt 401, {msg: "go away!"}.to_json unless current_user
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
  adventure = Adventure  #<--need a module there to replace TacoTweet
  [200, adventure.to_json]
end

# need to be able to store which token we've given to whom
# User.find() # save the token on that user
# User.create(token: token)
# User.where(token:


#1 Create a new Story record with a title   # Ryan needs an object(hash) with the name of the story and an id for the story
post '/storyname' do     # 500 server error for POSTs?
  # story.create(title)   Story title
end

# #2 Read a Story to json
# get '/storyread' do       # 400 Bad Request; for invalid user input?
#   # story_id.read.to_json  reading a story
# end
#
# #3 Update a Story record
# patch '/updatestory' do   # 500 like for POSTs
#   # story_id update partial
# end
#
# #4 Destroy a Story record
# delete '/removestory' do       # 303 See Other (since HTTP/1.1). The response to the request can be found under another URI using a GET method. When received in response to a POST (or PUT/DELETE), the client should presume that the server has received the data and should issue a redirect with a separate GET message.[28]
#   #what goes in this method?
#   # story_id.destroy
# end

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

#6 Read a Step to JSON
# get '/stepread' do
#   # step_id.read.to_json ?
# end
#
# #7 Update a Step record
# patch '/updatestep' do
#   # step_id  partial update
# end
# #8 Destroy a Step record
# # delete '/delete/:record' do
# #   # delete step record from db
# #   payload = JSON.parse(request.body.read)
# #   step_record = Step.find(params["id"]).update(payload)
# #   step_record.to_json
# # end
#
# #9 Read next Step, for a given Step, if one is present
# get '/nextstep'
#   # step_id.read   conditional until?
# end
