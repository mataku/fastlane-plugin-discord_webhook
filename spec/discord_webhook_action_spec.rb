require 'net/http'

describe Fastlane::Actions::DiscordWebhookAction do
  let(:action) { Fastlane::Actions::DiscordWebhookAction }
  let(:client) { Fastlane::DiscordWebhook::DiscordClient }
  let(:params) do
    {
      webhook_url: 'https://localhost:1000',
      message: 'hello'
    }
  end

  describe '#run' do
    context 'no webhook url' do
      it 'should raise error' do
        expect { action.run({}) }.to raise_error('`webhook_url:` parameter is invalid. Please provide a valid URL.')
      end
    end

    context 'webhook_url exists' do
      let(:successful_response) { instance_double(Net::HTTPSuccess, body: 'body', message: 'OK') }
      let(:mock_client) { instance_double('discord_client') }
      before do
        allow(successful_response).to receive(:kind_of?).with(Net::HTTPSuccess).and_return(true)
        allow(mock_client).to receive(:send_message).and_return(successful_response)
        allow(client).to receive(:new).and_return(mock_client)
        allow(Fastlane::UI).to receive(:success)
      end

      it 'should display successful message' do
        expect { action.run(params) }.not_to raise_error
        expect(Fastlane::UI).to have_received(:success).with('Successfully sent a message to Discord')
      end
    end

    context 'request failure' do
      let(:failure_response) { instance_double(Net::HTTPBadRequest, body: '{"message": "error"}', message: 'error') }
      let(:mock_client) { instance_double('discord_client') }
      before do
        allow(failure_response).to receive(:kind_of?).with(Net::HTTPSuccess).and_return(false)
        allow(mock_client).to receive(:send_message).and_return(failure_response)
        allow(client).to receive(:new).and_return(mock_client)
        allow(Fastlane::UI).to receive(:user_error!)
      end

      it 'should display failure message' do
        expect { action.run(params) }.not_to raise_error
        expect(Fastlane::UI).to have_received(:user_error!).with('Failed to send a message to Discord: error')
      end
    end

    context 'request failure unexpected JSON error message' do
      let(:body) { '{"hoge": "way"}' }
      let(:failure_response) { instance_double(Net::HTTPBadRequest, body: body) }
      let(:mock_client) { instance_double('discord_client') }
      before do
        allow(failure_response).to receive(:kind_of?).with(Net::HTTPSuccess).and_return(false)
        allow(mock_client).to receive(:send_message).and_return(failure_response)
        allow(client).to receive(:new).and_return(mock_client)
        allow(Fastlane::UI).to receive(:user_error!)
      end

      it 'should display failure message' do
        expect { action.run(params) }.not_to raise_error
        expect(Fastlane::UI).to have_received(:user_error!).with("Failed to send a message to Discord: #{body}")
      end
    end

    context 'request failure unexpected non-JSON error message' do
      let(:body) { 'hello' }
      let(:failure_response) { instance_double(Net::HTTPBadRequest, body: body) }
      let(:mock_client) { instance_double('discord_client') }
      before do
        allow(failure_response).to receive(:kind_of?).with(Net::HTTPSuccess).and_return(false)
        allow(mock_client).to receive(:send_message).and_return(failure_response)
        allow(client).to receive(:new).and_return(mock_client)
        allow(Fastlane::UI).to receive(:user_error!)
      end

      it 'should display failure message' do
        expect { action.run(params) }.not_to raise_error
        expect(Fastlane::UI).to have_received(:user_error!).with("Failed to send a message to Discord: #{body}")
      end
    end

  end
end
