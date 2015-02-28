module V1
  class TransactionsController < ApplicationController
    def create
      begin
        params.require(:balance)
        params.require(:description)
        params.require(:recipient)
        params.require(:sender)
      rescue => e
        render_error(
          'missing_parameter',
          "Missing parameter #{e.param}",
          400
        ) and return
      end

      recipient = User.where(:uuid => params[:recipient]).take
      sender = User.where(:uuid => params[:sender]).take

      if not recipient
        render_error(
          'recipient_missing',
          "recipient #{params[:recipient]} doesn't exist",
          400
        ) and return
      end

      if not sender
        render_error(
          'sender_missing',
          "sender #{params[:sender]} doesn't exist",
          400
        ) and return
      end

      transaction = Transaction.new(
        :balance => params[:balance],
        :description => params[:description],
        :recipient => recipient,
        :sender => sender
      )
      transaction.save
      render json: transaction.as_json, status: 201, location: v1_transaction_url(:id => transaction.uuid)
    end

    def index
      if params[:recipient].blank? && params[:sender].blank?
        render_error(
          'missing_sender_or_recipient',
          'At least one of sender or recipient must be passed',
          400
        ) and return
      end

      if params[:recipient]
        recipient = User.where(:uuid => params[:recipient])
      end
      if params[:sender]
        sender = User.where(:uuid => params[:sender])
      end

      if sender
        transactions = Transaction.where(:sender => sender)
      end

      if recipient
        transactions = Transaction.where(:recipient => recipient)
      end

      if sender && recipient
        transactions = Transaction.where(
          :sender => sender,
          :recipient => recipient
        )
      end

      transactions_as_json = transactions.to_json
      transactions_as_json = JSON.parse(transactions_as_json).map do |transaction|
        transaction['id'] = transaction['uuid']
        transaction.delete 'uuid'
        transaction
      end
      render json: transactions_as_json
    end
  end
end
