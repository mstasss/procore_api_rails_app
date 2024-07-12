ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def sign_in_with(access_token:)
      stub_request(:any, "#{Rails.configuration.procore_url}/oauth/token").to_return(status: 201, body: { access_token: access_token }.to_json, headers: { content_type: 'application/json' })
      get callback_session_oauth_url, params: { code: 'fake_code' }
    end
  end
end
