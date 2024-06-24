module Session
  class OauthController < ApplicationController
    skip_before_action :authenticate_user!

    before_action :redirect_if_signed_in, only: :new

    def new
      redirect_to oauth_client.auth_code.authorize_url(redirect_uri: callback_session_oauth_url), allow_other_host: true
    end

    def create
      new_token = oauth_client.auth_code.get_token(params[:code], redirect_uri: callback_session_oauth_url)
      sign_in(new_token)
      redirect_to projects_path
    end

    # get '/refresh' do
    # def update
    #   new_token = access_token.refresh!
    #   sign_in(new_token)
    #   redirect_to projects_path
    # end

    def destroy
      session[:access_token] = nil
      redirect_to root_path
    end

    private

    def redirect_if_signed_in
      redirect_to projects_path if signed_in?
    end
  end
end