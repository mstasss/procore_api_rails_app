class ApplicationController < ActionController::Base
  include Authentication

  before_action :authenticate_user!

  rescue_from OAuth2::Error do |error|
    Rails.logger.error(error.message)
    Rails.logger.error(access_token)

    flash[:error] = "Signed out due to OAuth Error: #{error.message}"

    sign_out!
    redirect_to home_path
  end
end
