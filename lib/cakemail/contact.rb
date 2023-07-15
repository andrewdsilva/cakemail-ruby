module Cakemail
  # @attr [String]          email             Email of the contact
  # @attr [String]          status            Status ex. "active"
  # @attr [Integer]         subscribed_on     Date of subscription (timestamp)
  # @attr [Integer]         bounces_count     Number of bounces
  # @attr [List]            list              List of the contact
  # @attr [Array<Hash>]     custom_attributes List of the custom attributes (name: value)
  class Contact < Base
    attr_accessor :email, :status, :subscribed_on, :bounces_count, :custom_attributes

    # Unsubscribe contact
    #
    # @return Contact
    #
    # @example
    #           contact = Cakemail::Contact.find(1, parent: list)
    #           contact.unsubscribe
    def unsubscribe(options = {})
      parent = get_parent(options)

      path = "#{self.class.object_class.path}/#{id}/unsubscribe"
      path = self.class.path_with_parent(path, parent) if parent

      response = Cakemail.post path, {}.to_json

      return response unless self.class.response_ok?(response)

      self.class.instantiate_object(response["data"]) unless response.nil?
    end

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

      @email             = options["email"]
      @status            = options["status"]
      @subscribed_on     = options["subscribed_on"]
      @bounces_count     = options["bounces_count"]
      @custom_attributes = options["custom_attributes"]
      @list              = parent
    end
  end
end
