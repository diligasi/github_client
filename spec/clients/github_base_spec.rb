require 'rspec'
require_relative '../../app/clients/github_base'
require_relative '../../app/http/client'

RSpec.describe Clients::GithubBase do
  let(:token)         { 'sample_token' }
  let(:repo_url)      { 'https://api.github.com' }
  let(:github_client) { described_class.new(token, repo_url) }

  describe '#fetch_paginated' do
    let(:endpoint) { '/repos/rails/rails/issues' }
    let(:params)   { { per_page: 2, page: 1 } }

    let(:response_page_1) do
      {
        'items' => [{ 'id' => 1, 'title' => 'Issue 1' }, { 'id' => 2, 'title' => 'Issue 2' }],
        'next' => '/repos/rails/rails/issues?page=2'
      }
    end
    let(:response_page_2) do
      {
        'items' => [{ 'id' => 3, 'title' => 'Issue 3' }],
        'next' => nil
      }
    end

    before do
      allow(github_client.instance_variable_get(:@http_client)).to receive(:get)
                                                                     .with(endpoint, github_client.send(:header), params)
                                                                     .and_return(response_page_1)
      allow(github_client.instance_variable_get(:@http_client)).to receive(:get)
                                                                     .with('/repos/rails/rails/issues?page=2', github_client.send(:header), params)
                                                                     .and_return(response_page_2)
    end

    it 'fetches all paginated items' do
      result = github_client.fetch_paginated(endpoint, params)
      expect(result).to eq([
                             { 'id' => 1, 'title' => 'Issue 1' },
                             { 'id' => 2, 'title' => 'Issue 2' },
                             { 'id' => 3, 'title' => 'Issue 3' }
                           ])
    end

    it 'makes the correct number of HTTP requests' do
      expect(github_client.instance_variable_get(:@http_client)).to receive(:get).twice
      github_client.fetch_paginated(endpoint, params)
    end
  end
end
