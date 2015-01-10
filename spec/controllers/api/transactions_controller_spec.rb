require 'rails_helper'

RSpec.describe Api::TransactionsController, :type => :controller do
  fixtures :users, :transactions

  describe 'POST' do
    before(:each) do
      @transaction = {
        :balance => 1000,
        :description => 'Foo bar',
        :sender => users(:complete).uuid,
        :recipient => users(:complete).uuid
      }
    end

    it 'should create transaction when all parameters given' do
      # when
      post :create, @transaction
      # then
      expect(response.status).to eql(201)
      expect(response.location).to eql(api_transaction_url(:id => Transaction.order(created_at: :desc).take.uuid))
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
      get :index
      # then
      expect(response.status).to eql(expected_status)
    end

    it 'should return transactions when recipient given' do
      # given
      user = users(:alice)
      transactions = Transaction.where(:recipient => user)
      expected_transactions_uuids = transactions.map {|transaction| transaction.uuid}
      # when
      get :index, { recipient: user.uuid }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions_uuids = given_transactions.map {|transaction| transaction['uuid']}
      given_transactions_uuids.sort!
      expect(given_transactions_uuids).to match_array(expected_transactions_uuids)
      expect(given_transactions_uuids.length).not_to be(0)
    end
    it 'should return transactions when sender given' do
      # given
      user = users(:alice)
      transactions = Transaction.where(:sender => user)
      expected_transactions_uuids = transactions.map {|transaction| transaction.uuid}
      # when
      get :index, { sender: user.uuid }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions_uuids = given_transactions.map {|transaction| transaction['uuid']}
      given_transactions_uuids.sort!
      expect(given_transactions_uuids).to match_array(expected_transactions_uuids)
      expect(given_transactions_uuids.length).not_to be(0)
    end

    it 'should return transactions when recipient and sender given' do
      # given
      sender = users(:alice)
      recipient = users(:bob)
      transactions = Transaction.where(
        :sender => sender,
        :recipient => recipient
      )
      expected_transactions_uuids = transactions.map {|transaction| transaction.uuid}
      # when
      get :index, {
        sender: sender.uuid,
        recipient: recipient.uuid
      }
      # then
      given_transactions = JSON.parse(response.body)
      given_transactions_uuids = given_transactions.map {|transaction| transaction['uuid']}
      given_transactions_uuids.sort!
      expect(given_transactions_uuids).to match_array(expected_transactions_uuids)
      expect(given_transactions_uuids.length).not_to be(0)
    end
  end

end
