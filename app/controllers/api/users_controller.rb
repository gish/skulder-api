class Api::UsersController < ApplicationController
  def index
    users = User.all.order(:uuid).as_json(
      :only => [:uuid, :given_name, :last_name, :email, :created_at, :updated_at]
    )
    render :json => users
  end

  def create
  end

  def destroy
  end

  def show
  end

  def update
  end
end
