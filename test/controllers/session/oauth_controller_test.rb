require "test_helper"

class Session::OauthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oauth_client_id = Rails.application.credentials.oauth_client_id
  end

  test "should get new" do
    get new_session_oauth_url
    assert_redirected_to "https://sandbox.procore.com/oauth/authorize?client_id=#{@oauth_client_id}&redirect_uri=http%3A%2F%2Flocalhost%3A4567%2Fsession%2Foauth%2Fcallback&response_type=code"
  end

  test "should create session" do
    req_stub = stub_request(:any, "#{Rails.configuration.procore_url}/oauth/token").to_return(status: 201, body: { access_token: 'fake_access_token' }.to_json, headers: { content_type: 'application/json' })

    get callback_session_oauth_url, params: { code: 'fake_code' }

    assert_equal('fake_access_token', session[:access_token])
    assert_requested req_stub, times: 1
    assert_redirected_to companies_url
  end

  test "should not create session" do
    req_stub = stub_request(:any, "#{Rails.configuration.procore_url}/oauth/token").to_return(status: 401, body: { error: 'Invalid Token' }.to_json, headers: { content_type: 'application/json' })

    get callback_session_oauth_url, params: { code: 'fake_code' }
    assert_redirected_to home_url
    assert_nil(session[:access_token])

    assert_requested req_stub, times: 1
  end

  test "should not get new if already signed in" do
    sign_in_with(access_token: 'fake_access_token')

    get new_session_oauth_url

    assert_not_requested :any, "#{Rails.configuration.procore_url}/oauth/authorize"
    assert_redirected_to companies_url
  end

  # test "should update session" do
  # end

  test "should destroy session" do
    delete session_oauth_url

    assert_nil(session[:access_token])
    assert_redirected_to root_url
  end
end
