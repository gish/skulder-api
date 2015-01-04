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
      render_error(
        'missing_parameter',
        "Missing parameter #{e.param}",
        400
      )
      return
    end
    if User.exists?(:email => params[:email])
      render_error(
        'email_exists',
        "User with e-mail address #{params[:email]} already exists",
        406
      )
      return
    end

    user = User.new(user_params)
    user.save

    render json: user.as_json, location: api_user_url(user.uuid)
  end

  def destroy
  end

  def show
    uuid = params[:id]
    user = User.where(:uuid => uuid).take
    render :json => user.as_json
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

    def render_error(type, description, code)
      error_body = {
        type: type,
        description: description
      }
      render json: error_body, status: code
    end
end
