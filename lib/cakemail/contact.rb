module Cakemail
  # @attr [String]          email         Email of the contact
  # @attr [String]          status        Status ex. "active"
  # @attr [Integer]         subscribed_on Date of subscription (timestamp)
  # @attr [Integer]         bounces_count Number of bounces
  # @attr [List]            list          List of the contact
  class Contact < Base
    attr_accessor :email, :status, :subscribed_on, :bounces_count

    def self.parent_required
      true
    end

    def self.no_parent_exception
      raise Cakemail::Base::NoParentError,
        "To request contacts, a list is required. Please use the parent option to pass it."
    end

    def self.object_class
      Cakemail::Contact
    end

    def self.path
      "contacts"
    end

    def initialize(options = {})
      super(options)

      @email         = options["email"]
      @status        = options["status"]
      @subscribed_on = options["subscribed_on"]
      @bounces_count = options["bounces_count"]
      @list          = parent
    end
  end
end
