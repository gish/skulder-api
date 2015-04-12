module V1
  class UsersController < ApplicationController
    def index
      users = User.all.order(:uuid)

      users_as_json = users.map do |user|
        user_hash = user.as_json
        user_hash['id'] = user.uuid
        user_hash.delete 'uuid'
        user_hash
      end
      render :json => users_as_json
    end

    def create
      begin
        params.require(:email)
        params.require(:given_name)
        params.require(:last_name)
      rescue => e
        render_error(
          'missing_parameter',
          "Missing parameter #{e.param}",
          400
        ) and return
      end
      if User.exists?(:email => params[:email])
        render_error(
          'email_exists',
          "User with e-mail address #{params[:email]} already exists",
          406
        ) and return
      end

      user = User.new(user_params)
      user.save

      render nothing: true, location: v1_user_url(user.uuid), status: 201
    end

    def destroy
    end

    def show
      uuid = params[:id]
      user = User.where(:uuid => uuid).take
      if user.blank?
        render_error(
          'user_not_found',
          "User #{uuid} doesn't exist",
          400
        ) and return
      end

      user_hash = user.as_json
      user_hash.delete 'id'

      render :json => user_hash
    end

    def update
    end

    def friends
      uuid = params[:id]
      user = User.where(:uuid => uuid).take
      if user.blank?
        render_error(
          'user_not_found',
          "User #{uuid} doesn't exist",
          400
        ) and return
      end
      transactions = Transaction.where(:sender => user)
      recipients_hash = transactions.map do |transaction|
        recipient = transaction.recipient
        recipient_hash = recipient.as_json
        recipient_hash.delete 'id'
        recipient_hash
      end

      transactions = Transaction.where(:recipient => user)
      senders_hash = transactions.map do |transaction|
        sender = transaction.sender
        sender_hash = sender.as_json
        sender_hash.delete 'id'
        sender_hash
      end
      render :json => recipients_hash | senders_hash
    end

    private
      def user_params
        params.permit(
          :given_name,
          :last_name,
          :email
        )
      end
  end
end
