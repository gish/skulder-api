require 'rails_helper'
require 'spec_helper'

describe Api::UsersController, :type => :controller do
  fixtures :users

  describe 'Get all users' do
    it 'should get all users when no uuid given' do
      expected = User.all.order(:uuid).as_json
      get :index
      users = JSON.parse(response.body)
      expect(users.length).to be(expected.length)
    end

    it 'should get user when uuid given and user exists' do
      # given
      expected_user = users(:complete)
      # when
      get :show, {'id' => users(:complete).uuid}
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
      get :show, {'id' => 'not-valid'}
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
      post :create, new_user.as_json
      # then
      location = response.location
      expect(response.status).to eql(201)
      expect(User.exists?(:email => new_user.email)).to be(true)
      expect(location).to eql(api_user_url(User.where(:email => new_user.email).take.uuid))
    end

    it 'should output error when user with email already exists' do
      # given
      new_user = users(:complete)
      expected_response = 406
      expected_type = 'email_exists'
      # when
      post :create, new_user.as_json
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
      post :create, new_user.as_json
      # then
      response_json = JSON.parse(response.body)
      expect(response.status).to eql(expected_response)
      expect(response_json['type']).to eql(expected_type)
    end
  end
end
