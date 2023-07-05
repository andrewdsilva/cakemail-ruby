module Cakemail
  # @attr [Integer]       id         Id of the list
  class Base
    attr_accessor :id

    # Returns Cakemail object with id and type provided
    #
    # @param id [String]
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           list = Cakemail::List.find(1)
    #           list.class #=> Cakemail::User
    #           list.id    #=> 1
    def self.find(id)
      path = "#{object_class.path}/#{id}"

      response = Cakemail.get path

      instantiate_object response["data"] unless response.nil?
    end

    # Returns Cakemail objects
    #
    # @param page [Integer]
    # @param per_page [Integer]
    # @return [Array<List>, Array<Contact>, Array<Campaign>, Array<Tags>]
    #
    # @example
    #           contacts = Cakemail::Contact.list(1, 50)
    def self.list(page = 1, per_page = 50)
      path = "#{object_class.path}?page=#{page}&per_page=#{per_page}"

      response = Cakemail.get path

      instantiate_object_list(response["data"]) unless response.nil?
    end

    # Returns total count
    #
    # @return Integer
    #
    # @example
    #           total_contacts = Cakemail::Contact.count
    def self.count
      path = "#{object_class.path}?page=1&per_page=1&with_count=true"

      response = Cakemail.get path

      response["pagination"]["count"] unless response.nil?
    end

    # Yields each batch of records that was found
    #
    # @param block [Block]
    #
    # @example
    #           total_contacts = Cakemail::Contact.count
    def self.find_in_batches(&block)
      total = count
      page = 1
      per_page = 50

      loop do
        list(page, per_page).each do |object|
          block.call(object)
        end

        break if page * per_page > total

        page += 1
      end
    end

    # Create a new object and return it
    #
    # @param params [Hash]
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           my_list = Cakemail::List.create(name: "My list")
    def self.create(params)
      path = object_class.path

      response = Cakemail.post path, params.to_json

      return response unless response_ok? response

      instantiate_object(response["data"]) unless response.nil?
    end

    # Delete Cakemail object
    #
    # @return Boolean
    #
    # @example
    #           list = Cakemail::List.find(1)
    #           list.delete
    def delete
      path = "#{self.class.object_class.path}/#{id}"

      response = Cakemail.delete path

      self.class.response_ok?(response) && response["deleted"]
    end

    # Update Cakemail object and return it
    #
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           list = Cakemail::List.find(1)
    #           list.update(name: "My list 2")
    def update(params)
      path = "#{self.class.object_class.path}/#{id}"

      response = Cakemail.patch path, params.to_json

      return response unless self.class.response_ok?(response) && response["updated"]

      self.class.instantiate_object(response["data"]) unless response.nil?
    end

    def self.response_ok?(response)
      [200, 201].include?(response["status_code"])
    end

    def initialize(options = {})
      @id = options["id"]
    end

    def self.object_class; end

    def self.instantiate_object_list(json)
      json.map { |json_object| instantiate_object(json_object) }
    end

    def self.instantiate_object(json)
      object_class.new json
    end

    def respond_to?(method_name)
      attr = "@#{method_name}"

      return super if method_name.match(/[?!]$/) || !instance_variable_defined?(attr)

      true
    end
  end
end
