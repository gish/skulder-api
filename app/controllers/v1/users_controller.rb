module V1
  class UsersController < ApplicationController
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
  end
end
