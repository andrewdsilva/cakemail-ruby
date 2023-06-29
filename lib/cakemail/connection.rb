require "dotenv/load"
require "faraday"

module Cakemail
  class MissingAuthentication < StandardError; end
  class JsonResponseError < StandardError; end

  API_URI = "https://api.cakemail.dev".freeze
  VERBS   = %w[get post put delete].freeze

  class << self
    attr_accessor :raw_response

    VERBS.each do |verb|
      define_method verb do |path, params|
        send_request(verb, path, params)
      end
    end

    def api_key
      Cakemail.config.api_key
    end

    def create_token(username = nil, password = nil)
      post("token", authentication_params(username, password))
    end

    private

    def authentication_params(username, password)
      username = ENV["CAKEMAIL_USERNAME"] if username.nil?
      password = ENV["CAKEMAIL_PASSWORD"] if password.nil?

      {
        grant_type: "password",
        scopes: "user",
        username: username,
        password: password
      }
    end

    def missing_authentication?(_response)
      false
    end

    def auth_header
      headers = { "accept" => "application/json", "content-Type" => "application/x-www-form-urlencoded" }
      headers < { "Authorization" => "Bearer #{api_key}" } if api_key

      headers
    end

    def send_request(verb, path, params)
      connection = Faraday.new(
        url: API_URI,
        headers: auth_header,
      )

      response = connection.send(verb.downcase.to_sym, path) do |req|
        req.body = JSON.generate(params)
      end

      pp response

      raise MissingAuthentication if missing_authentication? response

      begin
        JSON.parse(response.body)
      rescue
        raise JsonResponseError
      end
    end
  end
end
