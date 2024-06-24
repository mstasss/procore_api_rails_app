module Session
  class OauthController < ApplicationController
    include Authentication

    def new
      redirect_to oauth_client.auth_code.authorize_url(redirect_uri: callback_session_oauth_url), allow_other_host: true
    end

    def create
      new_token = oauth_client.auth_code.get_token(params[:code], redirect_uri: callback_session_oauth_url)
      sign_in(new_token)
      redirect_to projects_path
    end

    def destroy
      session[:access_token] = nil
      redirect_to root_path
    end

    private

    # get '/refresh' do
    #   new_token = access_token.refresh!
    #   sign_in(new_token)
    #   redirect_to projects_path
    # end
  end
end