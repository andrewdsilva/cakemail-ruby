module Cakemail
  # @attr [String]         name        Name of the list
  # @attr [String]         status      Ex. "active"
  # @attr [String]         language    Ex. "fr_CA"
  # @attr [Integer]        created_on  Timestamp Ex.1688012089
  # @attr [Array<Contact>] artists     The contacts of the list
  class List < Base
    attr_accessor :name, :status, :language, :created_on

    def self.object_class
      Cakemail::List
    end

    def self.path
      "lists"
    end

    def initialize(options = {})
      super(options)

      @name       = options["name"]
      @status     = options["status"]
      @language   = options["language"]
      @created_on = options["created_on"]
    end
  end
end
