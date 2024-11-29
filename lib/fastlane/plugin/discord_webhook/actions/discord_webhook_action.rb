require 'fastlane/action'
require 'json'
require 'net/http'
require_relative '../helper/discord_webhook_helper'
require_relative '../discord_client'

module Fastlane
  module Actions
    class DiscordWebhookAction < Action
      def self.run(params)
        webhook_url = params[:webhook_url]
        if webhook_url.nil? || webhook_url.empty?
          UI.user_error!('`webhook_url:` parameter is invalid. Please provide a valid URL.')
        end

        message = params[:message]
        username = params[:username]
        file_path = params[:attachment_file_path]
        embed_payload = params[:embed_payload]

        client = DiscordWebhook::DiscordClient.new(webhook_url)
        begin
          response = client.send_message(
            username: username,
            content: message,
            file_path: file_path,
            embed_payload: embed_payload
          )
          handle_response(response)
        rescue Socket::ResolutionError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError => e
          UI.user_error!(e.message)
        end
      end

      def self.description
        "Send a message using Discord Webhook"
      end

      def self.authors
        ["Takuma Homma"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Send a message using Discord Webhook"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :webhook_url,
            env_name: "FL_DISCORD_WEBHOOK_URL",
            description: "Discord Webhook URL",
            optional: false,
            type: String,
            verify_block: proc do |value|
              UI.user_error!('`webhook_url:` parameter is invalid. Please provide a valid URL.') if value.nil? || value.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :message,
            env_name: "FL_DISCORD_WEBHOOK_MESSAGE",
            description: "The message you want to send",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :username,
            env_name: "FL_DISCORD_WEBHOOK_USERNAME",
            description: "[Optional] Username",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :attachment_file_path,
            env_name: "FL_DISCORD_WEBHOOK_ATTACHMENT_FILE_PATH",
            description: "[Optional] File path to upload",
            optional: true,
            type: String,
            verify_block: proc do |value|
              if value
                UI.user_error!("#{value} not found! Specify correct file path.") unless File.exist?(value)
              end
            end
          ),
          # See: https://discord.com/developers/docs/resources/message#embed-object
          FastlaneCore::ConfigItem.new(
            key: :embed_payload,
            env_name: "FL_DISCORD_WEBHOOK_EMBED_PAYLOAD",
            description: "[Optional] Embed Object. You can specify one object. See details: https://discord.com/developers/docs/resources/message#embed-object",
            optional: true,
            type: Hash
          )
          # TODO: multiple file and embed contents if needed
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.handle_response(response)
        if response.kind_of?(Net::HTTPSuccess)
          UI.success('Successfully sent a message to Discord')
        else
          body = response.body
          error_body = begin
            parsed = JSON.parse(body)['message']
            if parsed.nil?
              body
            else
              parsed
            end
          rescue JSON::ParserError
            body
          end
          UI.user_error!("Failed to send a message to Discord: #{error_body}")
        end
      end
    end
  end
end
