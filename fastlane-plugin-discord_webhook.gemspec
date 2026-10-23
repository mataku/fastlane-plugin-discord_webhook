lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/discord_webhook/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-discord_webhook'
  spec.version       = Fastlane::DiscordWebhook::VERSION
  spec.author        = 'Takuma Homma'
  spec.email         = 'nagomimatcha@gmail.com'

  spec.summary       = 'A lightweight fastlane plugin to send a message via Discord Webhook'
  spec.homepage      = 'https://github.com/mataku/fastlane-plugin-discord_webhook'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(__dir__) { `git ls-files -z -- lib README.md LICENSE`.split("\x0") }
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  spec.required_ruby_version = '>= 3.2' # consider the versions supported by fastlane as much as possible
end
