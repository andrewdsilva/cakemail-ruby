module Cakemail
  class Base
    # Returns Cakemail object with id and type provided
    #
    # @param id [String]
    # @param type [String]
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           list = Cakemail::Base.find(1, 'list')
    #           list.class #=> Cakemail::User
    #           list.id    #=> 1
    def self.find(id)
      path = "#{object_class.path}/#{id}"

      response = Cakemail.get path

      instantiate_object response unless response.nil?
    end

    # Returns Cakemail objects
    #
    # @param type [String]
    # @param page [Integer]
    # @param per_page [Integer]
    # @return [Array<List>, Array<Contact>, Array<Campaign>, Array<Tags>]
    #
    # @example
    #           contacts = Cakemail::Base.list('contact', 1, 50)
    def self.list(type, page = 1, per_page = 50)
      type_class = Cakemail.const_get(type.capitalize)

      path = "#{type_class.path}?page=#{page}&per_page=#{per_page}"

      response = Cakemail.get path

      type_class.new response unless response.nil?
    end

    def initialize(options = {})
    end

    def self.object_class; end

    def self.instantiate_object(json)
      object_class.new json
    end

    def respond_to?(method_name)
      attr = "@#{method_name}"

      return super if method_name.match(/[\?!]$/) || !instance_variable_defined?(attr)

      true
    end
  end
end
