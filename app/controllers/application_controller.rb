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

  private

  def current_company_id
    raise NotImplementedError
  end

  def procore_api_client
    @procore_api_client ||= Procore::ApiClient.new(
      company_id: current_company_id,
      access_token: @access_token,
      refresh_token: -> { refresh_token! }
    )
  end

  def signed_in_as
    session[:signed_in_as] ||= procore_api_client.list_me
  end
  helper_method :signed_in_as
end
