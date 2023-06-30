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

    private

    def missing_authentication?(_response)
      false
    end

    def auth_header
      headers = { "accept" => "application/json", "content-Type" => "application/x-www-form-urlencoded" }
      headers < { "Authorization" => "Bearer #{api_key}" } if api_key

      headers
    end

    def send_request(http_verb, path, params)
      connection = Faraday.new(url: API_URI)
      response = connection.send(http_verb.downcase.to_sym, path, params, auth_header)

      raise MissingAuthentication if missing_authentication? response

      begin
        JSON.parse(response.body).merge("status_code" => response.status)
      rescue
        raise JsonResponseError
      end
    end
  end
end
