require 'fastlane_core/ui/ui'
require 'json'
require 'net/http'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class DiscordWebhookHelper
      # class methods that you define here become available in your action
      # as `Helper::DiscordWebhookHelper.your_method`

      def self.send_message_with_file(webhook_url:, username:, content:, file_path:, embed_title:, embed_description:, embed_url:, embed_icon_url:, debug: false)
        uri = URI.parse(webhook_url)
        request = Net::HTTP::Post.new(uri)
        payload_json = if !username.nil? && !username.empty?
                         { username: username, content: content }
                       else
                         { content: content }
                       end
        request.set_form(
          [
            [
              'payload_json',
              payload_json.to_json
            ],
            [
              'file1',
              File.open(file_path)
            ]
          ],
          'multipart/form-data'
        )
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true
        http.set_debug_output($stderr) if debug
        response = http.start do |h|
          h.request(request)
        end
        handle_response(response)
      end

      def self.send_message_with_embed(webhook_url:, username:, content:, embed_title:, embed_description:, embed_url:, embed_thumbnail_url:, debug: false)
        uri = URI.parse(webhook_url)
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        embed = {
          type: 'link',
          title: embed_title,
          description: embed_description,
          url: embed_url
        }
        if !embed_icon_url.nil? && !embed_icon_url.empty?
          embed[:thumbnail] = {
            url: embed_thumbnail_url
          }
        end

        body = {
          content: content,
          embeds: [embed]
        }
        body[:username] = username if !username.nil? && !username.empty?
        request.body = body.to_json

        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true
        http.set_debug_output($stderr) if debug
        response = http.start do |h|
          h.request(request)
        end

        handle_response(response)
      end

      def self.handle_response(response)
        if response.kind_of?(Net::HTTPSuccess)
          UI.success('Successfully sent a message to Discord')
        else
          error_body = JSON.parse(response.body)
          UI.user_error!("Failed to send a message to Discord: #{error_body}")
        end
      end
    end
  end
end
