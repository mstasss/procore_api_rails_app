module Authentication
  extend ActiveSupport::Concern

  private

  def authenticate_user!
    redirect_to home_path unless signed_in?
    refresh_token! if access_token.expired? || access_token.expires_at < Time.now.to_i + 5.seconds
  end

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
      oauth_client,
      session[:access_token],
      refresh_token: session[:refresh_token],
      expires_at: session[:access_token_expires_at],
      mode: :header,
      param_name: :access_token
    )
  end

  def sign_in!(token)
    sign_out!

    session[:access_token]  = token.token
    session[:refresh_token] = token.refresh_token
    session[:access_token_expires_at] = token.expires_at

    access_token
  end

  def sign_out!
    session.delete(:access_token)
    session.delete(:refresh_token)
    session.delete(:access_token_expires_at)
    session.delete(:signed_in_as)
    @access_token = nil
  end

  def refresh_token!
    new_token = access_token.refresh!
    sign_in!(new_token)
  end

  def signed_in?
    session[:access_token].present?
  end

  included do
    helper_method :signed_in?
  end
end
