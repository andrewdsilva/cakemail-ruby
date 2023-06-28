require "dotenv/load"

module Cakemail
  module Configuration
    def self.api_key
      @api_key
    end

    def self.api_key=(api_key)
      @api_key = api_key
    end

    DEFAULT = {
      api_key: ENV["CAKEMAIL_API_KEY"]
    }.freeze

    DEFAULT.each do |param, default_value|
      send("#{param}=", default_value)
    end
  end
end
