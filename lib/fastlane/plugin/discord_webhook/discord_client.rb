require 'json'
require 'net/http'

module Fastlane
  module DiscordWebhook
    class DiscordClient
      attr_accessor :webhook_url

      # @param webhook_url [String]
      def initialize(webhook_url)
        @webhook_url = webhook_url
      end

      # @param username [String]
      # @param content [String]
      # @param file_path [String]
      # @param embed_payload [Hash]
      # @param debug [Boolean]
      def send_message(username:, content:, file_path:, embed_payload:, debug: false)
        if file_path.nil? || file_path.empty?
          send_message_with_embed(username: username, content: content, embed_payload: embed_payload, debug: debug)
        else
          send_message_with_file(username: username, content: content, file_path: file_path, embed_payload: embed_payload, debug: debug)
        end
      end

      private

      # @param username [String]
      # @param content  [String]
      # @param file_path  [String]
      # @param embed_payload [Hash]
      # @param debug    [Boolean]
      def send_message_with_file(username:, content:, file_path:, embed_payload:, debug: false)
        uri = URI.parse(@webhook_url)
        request = Net::HTTP::Post.new(uri)
        embed_payload_content = if embed_payload.nil? || embed_payload.empty?
                                  []
                                else
                                  [embed_payload]
                                end
        payload_json = if !username.nil? && !username.empty?
                         {
                           username: username,
                           content: content,
                           embeds: embed_payload_content,
                           allowed_mentions: {
                             parse: ['users', 'roles'],
                           }
                         }
                       else
                         {
                           content: content, 
                           embeds: embed_payload_content,
                           allowed_mentions: {
                             parse: ['users', 'roles'],
                           }
                         }
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
        http.start do |h|
          h.request(request)
        end
      end

      # @param username [String]
      # @param content  [String]
      # @param embed_payload [Hash]
      # @param debug    [Boolean]
      def send_message_with_embed(username:, content:, embed_payload:, debug: false)
        uri = URI.parse(@webhook_url)
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        embed_payload_content = if embed_payload.nil? || embed_payload.empty?
                                  []
                                else
                                  [embed_payload]
                                end

        body = {
          content: content,
          embeds: embed_payload_content,
          allowed_mentions: {
            parse: ['users', 'roles'],
          }
        }
        body[:username] = username if !username.nil? && !username.empty?
        request.body = body.to_json

        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true
        http.set_debug_output($stderr) if debug
        http.start do |h|
          h.request(request)
        end
      end
    end
  end
end
