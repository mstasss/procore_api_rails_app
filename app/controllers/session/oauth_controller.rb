module Session
  class OauthController < ApplicationController
    skip_before_action :authenticate_user!

    before_action :redirect_if_signed_in, only: :new

    def new
      redirect_to oauth_client.auth_code.authorize_url(redirect_uri: callback_session_oauth_url), allow_other_host: true
    end

    def create
      new_token = oauth_client.auth_code.get_token(params[:code], redirect_uri: callback_session_oauth_url)
      sign_in!(new_token)
      redirect_to companies_path
    end

    # def update
    #   refresh_token!
    #   redirect_to some_path
    # end

    def destroy
      sign_out!
      redirect_to root_path
    end

    private

    def redirect_if_signed_in
      redirect_to companies_path if signed_in?
    end
  end
end
