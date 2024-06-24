class HttpClient
  def initialize(auth_url, auth_params = {}, headers = {})
    @auth_url = auth_url
    @auth_params = auth_params
    @provided_headers = headers
  end

  def get(url, query_params = {})
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(query_params) unless query_params.blank?

    retry_with_new_token do
      request(:get, uri.to_s)
    end
  end

  def post(url, body)
    retry_with_new_token do
      request(:post, url, body: body)
    end
  end

  private

  def request(method, url, options = {})
    Rails.logger.info "Sending HTTP #{method.upcase} #{url}"
    Rails.logger.info "Options: #{options}\n" unless options.blank?

    response = HTTP.request(method, url, options.reverse_merge(headers: headers))
    JSON.parse(response.body)
  rescue HTTP::ConnectionError => e
    raise e, "Request to #{url} failed: #{e.message}"
  rescue JSON::ParserError => e
    raise e, "Failed to parse response as JSON. Is the url (#{url}) correct? Truncated response:\n\n#{response.body.first(100)}"
  end

  def retry_with_new_token
    yield
  rescue HTTP::ConnectionError
    Rails.logger.info 'Retrying with new access token'
    @access_token = nil
    yield
  end

  def headers
    {
      **auth_headers,
      **@provided_headers
    }
  end

  def auth_headers
    {
      'Authorization' => "Bearer #{access_token}"
    }
  end

  def access_token
    @access_token ||= begin
      response = HTTP.post(@auth_url, json: @auth_params)
      JSON.parse(response.body).fetch('access_token')
    end
  end
end
