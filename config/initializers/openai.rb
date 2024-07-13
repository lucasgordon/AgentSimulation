# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
  config.uri_base = ENV["OPENAI_URI_BASE"]
end
