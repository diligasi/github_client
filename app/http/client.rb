require 'httparty'
require 'json'

module Http
  # Http::Client is a reusable HTTP client for making API requests.
  # It provides methods for the most common HTTP verbs: GET, POST, PUT, DELETE.
  #
  # Usage Example:
  #   client = Http::Client.new('https://api.example.com')
  #   response = client.get('/endpoint', { 'Authorization' => 'Bearer token' }, { query_key: 'value' })
  #
  # Arguments:
  # - @param base_url [String] Base URL for the API (e.g., https://api.example.com).
  #
  # Methods:
  # - `get(endpoint, headers = {}, params = {})`: Makes a GET request.
  # - `post(endpoint, headers = {}, body = {})`: Makes a POST request.
  # - `put(endpoint, headers = {}, body = {})`: Makes a PUT request.
  # - `delete(endpoint, headers = {}, body = {})`: Makes a DELETE request.
  #
  class Client
    include HTTParty

    def initialize(base_url)
      @base_url = base_url
    end

    def get(endpoint, headers = {}, params = {})
      self.class.get(full_url(endpoint), options(headers, params))
    end

    def post(endpoint, headers = {}, body = {})
      self.class.post(full_url(endpoint), options(headers, {}, body))
    end

    def put(endpoint, headers = {}, body = {})
      self.class.put(full_url(endpoint), options(headers, {}, body))
    end

    def delete(endpoint, headers = {}, body = {})
      self.class.delete(full_url(endpoint), options(headers, {}, body))
    end

    private

    def full_url(endpoint)
      "#{@base_url}#{endpoint}"
    end

    def default_headers
      { 'User-Agent' => 'Http::Client' }
    end

    def options(headers, params = {}, body = nil)
      {
        headers: default_headers.merge(headers),
        query: params,
        body: body&.to_json
      }
    end
  end
end
