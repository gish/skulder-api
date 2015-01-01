class Api::UsersController < ApplicationController
  def index
    users = User.all.order(:uuid).as_json
    render :json => users
  end

  def create
    user_params = params[:user]
    given_name = user_params[:given_name]
    last_name = user_params[:last_name]
    email = user_params[:email]

    user = User.new(
      :given_name => given_name,
      :last_name => last_name,
      :email => email
    )
    user.save

    render :json => user.as_json
  end

  def destroy
  end

  def show
  end

  def update
  end
end
