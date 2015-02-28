require 'rails_helper'

RSpec.describe V1::TransactionsController, :type => :controller do
  fixtures :users, :transactions, :api_keys

  before (:each) do
    @app_one = api_keys(:app_one)
    @alice = users(:alice)
  end

  describe 'POST' do
    before(:each) do
      @transaction = {
        :balance => 1000,
        :description => 'Foo bar',
        :sender => users(:complete).uuid,
        :recipient => users(:complete).uuid,
        :user_secret => @alice.secret,
        :api_key => @app_one.access_token
      }
    end

    it 'should create transaction when all parameters given' do
      # when
      post :create, @transaction
      # then
      expect(response.status).to eql(201)
      expect(response.location).to eql(v1_transaction_url(:id => Transaction.order(created_at: :desc).take.uuid))
    end


    it 'should output error when balance missing' do
      # given
      expected_type = 'missing_parameter'
      @transaction['balance'] = nil
      # when
      post :create, @transaction
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(400)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when description missing' do
      # given
      expected_type = 'missing_parameter'
      @transaction['description'] = nil
      # when
      post :create, @transaction
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(400)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when recipient missing' do
      # given
      expected_type = 'missing_parameter'
      @transaction['recipient'] = nil
      # when
      post :create, @transaction
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(400)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when sender missing' do
      # given
      expected_type = 'missing_parameter'
      @transaction['sender'] = nil
      # when
      post :create, @transaction
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(400)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when recipient doesn\'t exist' do
      # given
      expected_type = 'recipient_missing'
      @transaction['recipient'] = 'invalid'
      # when
      post :create, @transaction
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(400)
      expect(message['type']).to eql(expected_type)
    end

    it 'should output error when sender doesn\'t exist' do
      # given
      expected_type = 'sender_missing'
      @transaction['sender'] = 'invalid'
      # when
      post :create, @transaction
      # then
      message = JSON.parse(response.body)
      expect(response.status).to eql(400)
      expect(message['type']).to eql(expected_type)
    end
  end

  describe 'GET' do
    it 'should return error when recipient or sender not given' do
      # given
      expected_status = 400
      # when
      get :index, {
        :user_secret => @alice.secret,
        :api_key => @app_one.access_token
      }
      # then
      expect(response.status).to eql(expected_status)
    end

    it 'should return transactions when recipient given' do
      # given
      user = users(:alice)
      transactions = Transaction.where(:recipient => user)
      expected_transactions_ids = transactions.map {|transaction| transaction.uuid}
      # when
      get :index, {
        :recipient => user.uuid,
        :api_key => @app_one.access_token,
        :user_secret => @alice.secret
      }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions_ids = given_transactions.map {|transaction| transaction['id']}
      given_transactions_ids.sort!
      expect(given_transactions_ids).to match_array(expected_transactions_ids)
      expect(given_transactions_ids.length).not_to be(0)
    end

    it 'should return transactions when sender given' do
      # given
      user = users(:alice)
      transactions = Transaction.where(:sender => user)
      expected_transactions_ids = transactions.map {|transaction| transaction.uuid}
      # when
      get :index, {
        :sender => user.uuid,
        :api_key => @app_one.access_token,
        :user_secret => @alice.secret
      }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions_ids = given_transactions.map {|transaction| transaction['id']}
      given_transactions_ids.sort!
      expect(given_transactions_ids).to match_array(expected_transactions_ids)
      expect(given_transactions_ids.length).not_to be(0)
    end

    it 'should return transactions when recipient and sender given' do
      # given
      sender = users(:alice)
      recipient = users(:bob)
      transactions = Transaction.where(
        :sender => sender,
        :recipient => recipient
      )
      expected_transactions_ids = transactions.map {|transaction| transaction.uuid}
      # when
      get :index, {
        sender: sender.uuid,
        recipient: recipient.uuid,
        :api_key => @app_one.access_token,
        :user_secret => @alice.secret
      }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions_ids = given_transactions.map {|transaction| transaction['id']}
      given_transactions_ids.sort!
      expect(given_transactions_ids).to match_array(expected_transactions_ids)
      expect(given_transactions_ids.length).not_to be(0)
    end

    it 'should replace internal id with public id' do
      # given
      sender = users(:alice)
      recipient = users(:bob)
      transactions = Transaction.where(
        :sender => sender,
        :recipient => recipient
      ).order('uuid ASC')

      # when
      get :index, {
        sender: sender.uuid,
        recipient: recipient.uuid,
        api_key: @app_one.access_token,
        user_secret: sender.secret
      }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions.sort! { |x,y| x['id'] <=> y['id'] }
      expect(given_transactions[0]['id']).to eql transactions[0].uuid
    end
  end
end
