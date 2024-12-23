require_relative '../http/client'

module Clients
  # This class is responsible for interacting with the GitHub API.
  # It provides functionality to fetch paginated data from any endpoint that returns paginated results.
  #
  # Arguments:
  # Initializes the GithubBase client with a GitHub token and a repository URL.
  # - @param token [String] The personal access token for GitHub API authentication.
  # - @param repo_url [String] The repository URL for the GitHub API client.
  #
  # Methods
  # - `fetch_paginated(endpoint, params = {})`: Fetches all paginated items from a given endpoint. It handles pagination automatically by following the 'next' link in the response.
  #
  class GithubBase
    def initialize(token, repo_url)
      @http_client = Http::Client.new(repo_url)
      @token = token
    end

    def fetch_paginated(endpoint, params = {})
      items = []
      response = @http_client.get(endpoint, header, params)
      response.each do |item|
        items << item
      end
      items
    end

    private

    def header
      { 'Authorization' => "Bearer #{@token}" }
    end
  end
end
