# discord_webhook plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-discord_webhook)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-discord_webhook`, add it to your project by running:

```bash
fastlane add_plugin discord_webhook
```

You must create a webhook before using library. See details: https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks.

## About discord_webhook

A lightweight fastlane plugin to send a message using Discord Webhook

## Parameters

| Key | Description |
| --- | --- |
| `webhook_url` | Discord Webhook URL. |
| `username` | [Optional] Username. It will override webhook's username if specified. |
| `message`  | The message you want to send. |
| `attachment_file_path` | [Optional] File path to upload. See details for supported types: https://discord.com/developers/docs/reference#uploading-files |
| `embed_payload` | [Optional] Embed Object. You can specify one object. See details: https://discord.com/developers/docs/resources/message#embed-object |

## Example

```ruby
# Send a simple message
lane :discord_message do
  discord_webhook(
    webhook_url: 'https://yourDiscordWebhookUrl',
    message: 'hello',
    # You can override username by specifying it if needed.
    # username: 'mataku'
  )
end
```

```ruby
# Send a message with a file
lane :discord_message_with_file do
  discord_webhook(
    webhook_url: 'https://yourDiscordWebhookUrl',
    message: 'hello',
    attachment_file_path: '/home/mataku/screenshot.png',
    # Be careful to use relative path.
    # Fastfile is into fastlane/, but fastlane tries to load from working directory.
  )
end
```

```ruby
# Send a message with embed content
lane :discord_message_with_embed do
  discord_webhook(
    webhook_url: 'https://yourDiscordWebhookUrl',
    message: 'hello',
    embed_payload: {
      title: 'embed_title',
      description: 'embed_description',
      url: 'https://github.com/mataku',
      thumbnail: {
        url: 'https://github.com/mataku.png'
      }
    }
  )
end
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.
