require 'rails_helper'

RSpec.describe Api::DebtsController, :type => :controller do
  fixtures :users

  describe 'POST' do
    it 'should create Debt when all parameters given' do
      # given
      debt = {
        :amount => 1000,
        :description => 'Foo bar',
        :collector => users(:complete).uuid,
        :loaner => users(:complete).uuid
      }
      # when
      post :create, debt
      # then
      expect(response.status).to eql(201)
      expect(response.location).to eql(api_debt_url(:id => Debt.order(created_at: :desc).take.uuid))
    end

    it 'should output error when amount missing'
    it 'should output error when description missing'
    it 'should output error when loaner missing'
    it 'should output error when collector missing'
    it 'should output error when loaner doesn\'t exist'
    it 'should output error when collector doesn\'t exist'
  end

  describe 'GET' do
    it 'should return error when loaner or collector not given'
    it 'should return debts when loaner given'
    it 'should return debts when collector given'
    it 'should return debts when loaner and collector given'
  end
end
