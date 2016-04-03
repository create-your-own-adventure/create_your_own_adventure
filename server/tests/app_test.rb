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
    user = User.create   # no, i want this to test the value not the key
    User.find(1)
    response = post("/user", { "CONTENT_TYPE" => "application/json" })
    assert response.ok?
    payload = JSON.parse(response.body)
    binding.pry  # => user.token? false; user.valid? true

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
    # assert user.has_token?
  end
  # User.find() # save the token on that user
  # User.create(token: token)
  # User.where(token:


  # def test_get_returns_empty_json_when_no_taco_tweet
  #   response = get "/tweets"
  #   json = JSON.parse(response.body)
  #   assert_equal [], json
  # end
  #
  # def test_get_a_list_of_tweets
  #   tweet = Tweet.create(body: "Hello Taco!")
  #   response = get "/tweets"
  #   json = JSON.parse(response.body)
  #   assert_equal tweet.body, json.last["body"]
  # end
end
