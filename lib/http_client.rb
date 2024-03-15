class HttpClient
  RequestError = Class.new(StandardError)

  def initialize(auth_url, auth_params={}, headers={})
    @auth_url = auth_url
    @auth_params = auth_params || {}
    @provided_headers = headers || {}
  end

  def get(url, query_params={})
    uri = URI.parse(url)
    query_params = query_params.reject(&:blank?)
    uri.query = URI.encode_www_form(query_params) unless query_params.blank?

    handle_request_errors do
      HTTP.get(uri, headers: headers)
    end
  end

  def post(url, body)
    handle_request_errors do
      HTTP.post(url, headers: headers, json: body)
    end
  end

  private

  def handle_request_errors
    response = begin
      yield
    rescue HTTP::ConnectionError
      @access_token = nil # force a new access token
      yield
    end

    JSON.parse(response.body)
  rescue HTTP::ConnectionError => e
    raise RequestError, e.message
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

      JSON.parse(response.body)['access_token']
    end
  end
end
