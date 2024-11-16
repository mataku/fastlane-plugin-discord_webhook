require 'net/http'
require 'webmock/rspec'

describe Fastlane::DiscordWebhook::DiscordClient do
  let(:webhook_url) { 'https://example.com' }
  let(:username) { 'username' }
  let(:message) { 'hello' }
  let(:file_path) { './spec/fixtures/test.txt' }
  let(:file) { StringIO.new('test', 'w') }

  describe 'send_message' do
    before do
      allow(File).to receive(:open).with(file_path).and_return(file)
    end

    context 'file_path exists' do
      before do
        WebMock.stub_request(:post, webhook_url).with(
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        ).to_return(status: 204)
      end

      it 'should request multipart/form-data' do
        client = Fastlane::DiscordWebhook::DiscordClient.new(webhook_url)
        response = client.send_message(
          username: username,
          content: message,
          file_path: file_path,
          embed_payload: {}
        )
        expect(response.kind_of?(Net::HTTPSuccess)).to eq(true)
        expect(File).to have_received(:open).with(file_path).once
      end
    end

    context 'file_path is missing' do
      before do
        WebMock.stub_request(:post, webhook_url).with(
          headers: {
            'Content-Type': 'application/json'
          }
        ).to_return(status: 200, body: 'body')
      end

      it 'should request application/json' do
        client = Fastlane::DiscordWebhook::DiscordClient.new(webhook_url)
        response = client.send_message(
          username: username,
          content: message,
          file_path: nil,
          embed_payload: {}
        )
        expect(response.kind_of?(Net::HTTPSuccess)).to eq(true)
        expect(File).not_to have_received(:open).with(file_path)
      end
    end

    context 'request failed' do
      before do
        WebMock.stub_request(:post, webhook_url).with(
          headers: {
            'Content-Type': 'application/json'
          }
        ).to_return(status: 400, body: 'body')
      end

      it 'should return net/http failure response' do
        client = Fastlane::DiscordWebhook::DiscordClient.new(webhook_url)
        response = client.send_message(
          username: username,
          content: message,
          file_path: nil,
          embed_payload: {}
        )
        expect(response.kind_of?(Net::HTTPSuccess)).to eq(false)
      end
    end
  end
end
