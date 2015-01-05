require 'rails_helper'

RSpec.describe Api::DebtsController, :type => :controller do
  fixtures :users

  describe 'POST' do
    before(:each) do
      @debt = {
        :amount => 1000,
        :description => 'Foo bar',
        :collector => users(:complete).uuid,
        :loaner => users(:complete).uuid
      }
    end

    it 'should create Debt when all parameters given' do
      # when
      post :create, @debt
      # then
      expect(response.status).to eql(201)
      expect(response.location).to eql(api_debt_url(:id => Debt.order(created_at: :desc).take.uuid))
    end

    it 'should output error when amount missing' do
      # given
      expected_type = 'missing_parameter'
      @debt['amount'] = nil
      # when
      post :create, @debt
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(403)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when description missing' do
      # given
      expected_type = 'missing_parameter'
      @debt['description'] = nil
      # when
      post :create, @debt
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(403)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when loaner missing' do
      # given
      expected_type = 'missing_parameter'
      @debt['loaner'] = nil
      # when
      post :create, @debt
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(403)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when collector missing' do
      # given
      expected_type = 'missing_parameter'
      @debt['collector'] = nil
      # when
      post :create, @debt
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(403)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when loaner doesn\'t exist' do
      # given
      expected_type = 'loaner_missing'
      @debt['loaner'] = 'invalid'
      # when
      post :create, @debt
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(403)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when collector doesn\'t exist' do
      # given
      expected_type = 'collector_missing'
      @debt['collector'] = 'invalid'
      # when
      post :create, @debt
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(403)
      expect(message['type']).to eql(expected_type)
    end
  end

  describe 'GET' do
    it 'should return error when loaner or collector not given'
    it 'should return debts when loaner given'
    it 'should return debts when collector given'
    it 'should return debts when loaner and collector given'
  end
end
