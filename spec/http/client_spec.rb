require 'rspec'
require 'httparty'
require_relative '../../app/http/client'

RSpec.describe Http::Client do
  let(:base_url)      { 'https://api.example.com' }
  let(:client)        { Http::Client.new(base_url) }
  let(:endpoint)      { '/test-endpoint' }
  let(:headers)       { { 'Authorization' => 'Bearer token' } }
  let(:params)        { { key: 'value' } }
  let(:body)          { { name: 'example' } }
  let(:response_body) { { "message" => "success" } }

  before do
    allow(Http::Client).to receive(:get).and_return(double(parsed_response: response_body))
    allow(Http::Client).to receive(:post).and_return(double(parsed_response: response_body))
    allow(Http::Client).to receive(:put).and_return(double(parsed_response: response_body))
    allow(Http::Client).to receive(:delete).and_return(double(parsed_response: response_body))
  end

  shared_examples 'an HTTP request' do |method|
    it "sends a #{method.upcase} request and returns the parsed response" do
      response = client.public_send(method, endpoint, headers, method == :get ? params : body)

      expect(Http::Client).to have_received(method).with(
        "#{base_url}#{endpoint}",
        headers: { 'User-Agent' => 'Http::Client', 'Authorization' => 'Bearer token' },
        query: method == :get ? params : {},
        body: %i[post put delete].include?(method) ? body.to_json : nil
      )
      expect(response.parsed_response).to eq(response_body)
    end
  end

  describe '#get' do
    it_behaves_like 'an HTTP request', :get
  end

  describe '#post' do
    it_behaves_like 'an HTTP request', :post
  end

  describe '#put' do
    it_behaves_like 'an HTTP request', :put
  end

  describe '#delete' do
    it_behaves_like 'an HTTP request', :delete
  end
end
