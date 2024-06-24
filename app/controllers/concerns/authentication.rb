module Authentication
  extend ActiveSupport::Concern

  def oauth_client
    @oauth_client ||= OAuth2::Client.new(
      Rails.application.credentials.oauth_client_id,
      Rails.application.credentials.oauth_client_secret,
      site: Rails.configuration.procore_url,
      token_method: :post
    )
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new(
      client,
      session[:access_token],
      refresh_token: session[:refresh_token],
      mode: :query,
      param_name: :access_token
    )
  end

  def sign_in(token)
    session[:access_token]  = token.token
    session[:refresh_token] = token.refresh_token
  end

  def signed_in?
    !session[:access_token].nil?
  end
end
