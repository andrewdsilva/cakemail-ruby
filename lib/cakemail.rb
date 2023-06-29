require_relative "cakemail/version"
require_relative "cakemail/configuration"
require_relative "cakemail/connection"

module Cakemail
  class Error < StandardError; end

  def self.configure
    yield Cakemail::Configuration
  end

  def self.config
    Cakemail::Configuration
  end

  autoload :Base, "cakemail/base"
end
