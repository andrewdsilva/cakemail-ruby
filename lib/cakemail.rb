require_relative "cakemail/version"
require_relative "cakemail/configuration"

module Cakemail
  class Error < StandardError; end

  def self.configure
    yield Cakemail::Configuration
  end

  def self.config
    Cakemail::Configuration
  end
end
