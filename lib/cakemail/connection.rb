require "dotenv/load"
require "faraday"

module Cakemail
  class MissingAuthentication < StandardError; end
  class JsonResponseError < StandardError; end

  API_URI = "https://api.cakemail.dev".freeze
  VERBS   = %w[get post patch delete].freeze

  class << self
    attr_accessor :raw_response

    VERBS.each do |verb|
      define_method verb do |path, params = {}, headers = {}|
        send_request(verb, path, params, headers)
      end
    end

    def api_key
      Cakemail.config.api_key
    end

    private

    def parse_json(json)
      JSON.parse(json)
    rescue
      raise JsonResponseError
    end

    def missing_authentication?(response)
      parse_json(response.body)&.dig("detail") == "Not authenticated"
    end

    def auth_header
      headers = { "accept" => "application/json", "Content-Type" => "application/json" }
      headers = headers.merge("authorization" => "Bearer #{api_key}") if api_key

      headers
    end

    def send_request(http_verb, path, params, headers)
      connection = Faraday.new(url: API_URI)
      response = connection.send(http_verb.downcase.to_sym, path, params, auth_header.merge(headers))

      raise MissingAuthentication if missing_authentication? response

      parse_json(response.body).merge("status_code" => response.status)
    end
  end
end
