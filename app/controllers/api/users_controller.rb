class Api::UsersController < ApplicationController
  def index
    users = User.all.order(:uuid).as_json
    render :json => users
  end

  def create
    begin
      params.require(:email)
      params.require(:given_name)
      params.require(:last_name)
    rescue => e
      error_body = {
        type: "missing_parameter",
        description: "Missing parameter #{e.param}"
      }
      render json: error_body, status: 400
      return
    end

    user = User.new(user_params)
    user.save

    render :json => user.as_json
  end

  def destroy
  end

  def show
  end

  def update
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
