require 'rails_helper'
require 'spec_helper'

describe V1::UsersController, :type => :controller do
  fixtures :users, :api_keys

  before (:each) do
    @alice = users(:alice)
    @app_one = api_keys(:app_one)
  end


  describe 'Get all users' do
    it 'should get all users when no uuid given' do
      expected = User.all.order(:uuid).as_json
      get :index, {
        'user_secret' => @alice.secret,
        'api_key' => @app_one.access_token
      }

      users = JSON.parse(response.body)
      expect(users.length).to be(expected.length)
    end

    it 'should replace internal id with public id' do
      # given
      expected_id = User.all.order(:uuid).take.uuid
      # when
      get :index, {
        'user_secret' => @alice.secret,
        'api_key' => @app_one.access_token
      }
      # then
      given_users = JSON.parse(response.body)
      expect(given_users[0]['id']).to eql(expected_id)
    end

    it 'should get user when uuid given and user exists' do
      # given
      expected_user = users(:complete)
      # when
      get :show, {
        'id' => users(:complete).uuid,
        'user_secret' => @alice.secret,
        'api_key' => @app_one.access_token
      }
      # then
      returned_user = JSON.parse(response.body)
      assert_response :success
      expect(returned_user['uuid']).to eql(expected_user.uuid)
      expect(returned_user['given_name']).to eql(expected_user.given_name)
      expect(returned_user['last_name']).to eql(expected_user.last_name)
      expect(returned_user['email']).to eql(expected_user.email)
    end

    it 'should output error when getting non existing user' do
      # given
      expected_response = 400
      expected_type = 'user_not_found'
      # when
      get :show, {
        'id' => 'not-valid',
        'user_secret' => @alice.secret,
        'api_key' => @app_one.access_token
      }
      # then
      response_json = JSON.parse(response.body)
      expect(response.status).to eql(expected_response)
      expect(response_json['type']).to eql(expected_type)
    end
  end

  describe 'Create user' do
    it 'should create new user when POST valid user' do
       # given
      new_user = User.new(
        :email => 'new@foo.com',
        :given_name => 'New',
        :last_name => 'Foo'
      )
      # when
      post :create, {
        :email => new_user.email,
        :given_name => new_user.given_name,
        :last_name => new_user.last_name,
        :user_secret => @alice.secret,
        :api_key => @app_one.access_token
      }
      # then
      location = response.location
      expect(response.status).to eql(201)
      expect(User.exists?(:email => new_user.email)).to be(true)
      expect(location).to eql(v1_user_url(User.where(:email => new_user.email).take.uuid))
    end

    it 'should output error when user with email already exists' do
      # given
      new_user = users(:complete)
      expected_response = 406
      expected_type = 'email_exists'
      # when
      post :create, {
        :email => new_user.email,
        :given_name => new_user.given_name,
        :last_name => new_user.last_name,
        :user_secret => @alice.secret,
        :api_key => @app_one.access_token
      }
      # then
      response_json = JSON.parse(response.body)
      expect(response.status).to eql(expected_response)
      expect(response_json['type']).to eql(expected_type)
    end

    it 'should output error when last name is missing' do
      # given
      new_user = users(:missing_last_name)
      expected_response = 400
      expected_type = 'missing_parameter'
      # when
      post :create, {
        :email => new_user.email,
        :given_name => new_user.given_name,
        :user_secret => @alice.secret,
        :api_key => @app_one.access_token
      }
      # then
      response_json = JSON.parse(response.body)
      expect(response.status).to eql(expected_response)
      expect(response_json['type']).to eql(expected_type)
    end
  end
end
