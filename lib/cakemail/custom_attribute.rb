module Cakemail
  # @attr [String]         name        Name of the list
  # @attr [String]         type        Ex. "text", "integer"
  class CustomAttributes < Base
    attr_accessor :name, :type

    def self.parent_required
      true
    end

    def self.no_parent_exception
      raise Cakemail::Base::NoParentError,
        "To request custom attributes, a list is required. Please use the parent option to pass it."
    end

    def self.object_class
      Cakemail::CustomAttributes
    end

    def self.path
      "custom-attributes"
    end

    def initialize(options = {})
      super(options)

      @name = options["name"]
      @type = options["type"]
    end
  end
end
