class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :render_error

  def render_error(type, description, code)
    error_body = {
      type: type,
      description: description
    }
    render json: error_body, status: code
  end
end
