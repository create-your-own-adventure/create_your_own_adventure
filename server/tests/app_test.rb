require_relative "test_helper"
require "pry"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # def test_declares_its_name
  #   response = get "/backend"
  #   assert response.ok?
  #   assert_equal "I am Groot!", response.body
  # end

  # def test_backend_echo_endpoint_will_return_exact_msg_back
  #   hash = { "name" => "bob" }
  #   response = post("/backend/echo", hash.to_json, { "CONTENT_TYPE" => "application/json" })
  #   assert response.ok?
  #   payload = JSON.parse(response.body)
  #   assert_equal(hash, payload)
  # end

  def test_endpoint_path
    hash = { "sam" => "iam" }
    response = post("/", hash.to_json, { "CONTENT_TYPE" => "application/json" })
    # assert response.ok?
    payload = JSON.parse(response.body)
    assert_equal(hash, payload)
  end

  def test_login_token_creation
    token_size = 36  # "c75b864697 dae6bcd932 a0fddde536 02" }  "#{/^[a-zA-Z0-9]*$/}"
    response = post("/login", { "CONTENT_TYPE" => "application/json" })
    assert response.ok?
    payload = JSON.parse(response.body)   # JSON::ParserError: 784: unexpected token at '<h1>Not Found</h1>'
    # binding.pry    # payload.values outputs the token number ...
    assert_equal(token_size, payload.values.to_s.length)   # i don't know how to test for behavior here... payload.values.to_s.length
  end

  def test_user_with_token_creation
    # user = User.create   # no, i want this to test the value not the key
    user = User.find(1) # User.find(1) => #<User:0x007fe8f3a035a0 id: 1, token: "3f1e7075799141b3a9fb82f2bf5fd61e", created_at: 2016-04-03 13:42:44 UTC, updated_at: 2016-04-03 13:42:44 UTC>
    # response = post("/user", { "CONTENT_TYPE" => "application/json" })
    # assert response.ok?
    # binding.pry  # response.body => "{}"   # response.header => {"Content-Type"=>"application/json", "Content-Length"=>"2", "X-Content-Type-Options"=>"nosniff"}
    # payload = JSON.parse(response.body)
    # binding.pry  # => user.token? false; user.valid? true

    # user.update_attribute   # persistence methods available!
    #     .update_attributes
    #     .invalid?           # validation method looks like it might be useful
    #     .valid?
#         validates_absence_of       validates_format_of        validates_presence_of
#         validates_acceptance_of    validates_inclusion_of     validates_size_of
#         validates_confirmation_of  validates_length_of
#         validates_exclusion_of     validates_numericality_of
     #    .read_atribute      # attribute method
    #     .token?             # class methods
    #     .id?

    # User.where(token: token)
    assert true, user.token?
  end
  # User.find() # save the token on that user
  # User.create(token: token)
  # User.where(token:


  # def test_get_returns_empty_json_when_no_story
  #   response = get "/storyname"
  #   json = JSON.parse(response.body)
  #   assert_equal [], json   # returns true when the db is cleared
  # end


  def test_story_create
    # skip
    story = Story.create(name: "rando story name")
    response = get "/storyname"
    json = JSON.parse(response.body)
    assert_equal story.name, json.last["name"]
    # binding.pry
  end
  # def test_create_a_story
  #     story = Story.create(body: "Hello Taco!")
  #     assert_equal Story, story.class
  #     assert_equal false, story.id == nil
  # end

  # def test_get_a_list_of_tweets
  #   tweet = Tweet.create(body: "Hello Taco!")
  #   response = get "/tweets"
  #   json = JSON.parse(response.body)
  #   assert_equal tweet.body, json.last["body"]
  # end

  def test_story_has_id
    Story.create(name: "rando story name")
    response = get "/storyname"
    json = JSON.parse(response.body)
    assert_equal true, json.first.has_key?("id")
  end

  def test_story_has_name
    # skip
    new_story = Story.create(name: "bizarro adventure")
    response = get "/storyname"
    json = JSON.parse(response.body)
    assert_equal new_story.name, json.last["name"]
  end

# 3:
  def test_can_update_a_story
    # skip
    Story.where(name: "bizarro adventure")
    response = patch name: "excellent adventure" # "/storyname"
    json = JSON.parse(response.body)
    # patch ????
    assert_equal new_story.name, json.last["name"]
  end
# If the goal of patch is to "update/change" a an item, the best way I see is, create a Story/Step and
# then attempt to change it's name with your patch request.   And check your servers response that it now
# has the new name, as well as that name being in the database


# 4:
  def test_can_delete_a_story
    skip
    story = Story.create
    delete "/storyname/#{story.id}"
    response = last_response.body
    assert_equal false, Story.exists?(story.id)
  end

end
