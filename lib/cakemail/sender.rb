module Cakemail
  # @attr [String]        name                      Name of the sender
  # @attr [String]        email                     Email of the sender
  # @attr [Boolean]       confirmed                 Is sender confirmed
  # @attr [Integer]       confirmed_on              Timestamp Ex.1688012089
  # @attr [String]        language                  Ex. "fr_CA"
  # @attr [Integer|null]  last_confirmation_sent_on Timestamp Ex.1688012089
  class Sender < Base
    attr_accessor :name, :email, :confirmed, :confirmed_on, :language, :last_confirmation_sent_on

    def self.object_class
      Cakemail::Sender
    end

    def self.path
      "brands/default/senders"
    end

    def initialize(options = {})
      super(options)

      @name                      = options["name"]
      @email                     = options["email"]
      @confirmed                 = options["confirmed"]
      @confirmed_on              = options["confirmed_on"]
      @language                  = options["language"]
      @last_confirmation_sent_on = options["last_confirmation_sent_on"]
    end
  end
end
