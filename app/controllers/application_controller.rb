class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :restrict_access

  helper_method :render_error

  def render_error(type, description, code)
    error_body = {
      type: type,
      description: description
    }
    render json: error_body, status: code
  end

  private
    def restrict_access
      user_exists = User.exists?(:secret => params[:user_secret])
      api_key_exists = ApiKey.exists?(:access_token => params[:api_key])

      render_error(
        'invalid_user',
        'User secret or access token invalid',
        401
      ) unless (user_exists and api_key_exists)
    end
end
