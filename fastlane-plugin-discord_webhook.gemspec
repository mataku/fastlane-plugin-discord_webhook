lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/discord_webhook/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-discord_webhook'
  spec.version       = Fastlane::DiscordWebhook::VERSION
  spec.author        = 'Takuma Homma'
  spec.email         = 'nagomimatcha@gmail.com'

  spec.summary       = 'A lightweight fastlane plugin to send a message via Discord Webhook'
  spec.homepage      = "https://github.com/mataku/fastlane-plugin-discord_webhook"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.7' # consider the versions supported by fastlane as much as possible
end
