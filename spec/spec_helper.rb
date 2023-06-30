# frozen_string_literal: true

require "cakemail"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data("<FILTERED>") do |interaction|
    request = interaction.request
    response = interaction.response
    body = request.body.to_s

    body.gsub!(/"username":\s*"[^"]+"/, '"username": "<FILTERED>"')
    body.gsub!(/"password":\s*"[^"]+"/, '"password": "<FILTERED>"')

    if response.body.include?('access_token')
      new_body = response.body.gsub(/"access_token":"[^"]+"/, '"access_token":"<TOKEN_PLACEHOLDER>"')
      new_body = new_body.gsub(/"refresh_token":"[^"]+"/, '"refresh_token":"<TOKEN_PLACEHOLDER>"')

      response.body = new_body
    end

    request.body = body

    body
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
