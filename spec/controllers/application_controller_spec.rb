require 'rails_helper'
require 'spec_helper'

describe ApplicationController do
  fixtures :api_keys, :users

  controller do
    def index
    end
  end

  before (:each) do
    @alice = users(:alice)
    @app_one = api_keys(:app_one)
  end

  describe 'Authorization' do
    it 'should return error when user secret invalid' do
      # given
      expected_status = 401
      # when
      get :index, {
        :api_key => @app_one.access_token
      }
      # then
      expect(response.status).to eql(expected_status)
    end

    it 'should return error when api key invalid' do
      # given
      expected_status = 401
      # when
      get :index, {
        :user_secret => @alice.secret
      }
      # then
      expect(response.status).to eql(expected_status)
    end
  end
end
