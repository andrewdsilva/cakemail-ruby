module Cakemail
  # @attr [Integer]       id         Id of the list
  class Base
    class NoParentError < StandardError; end

    attr_accessor :id, :parent

    # Returns Cakemail object with id and type provided
    #
    # @param id [String]
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           list = Cakemail::List.find(1)
    #           list.class #=> Cakemail::User
    #           list.id    #=> 1
    def self.find(id, options = {})
      parent = get_parent(options)

      path = "#{object_class.path}/#{id}"
      path = path_with_parent(path, parent) if parent

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
    def self.list(options = {})
      page     = options[:page]     || 1
      per_page = options[:per_page] || 50
      filters  = options[:filters]  || {}
      parent   = options[:parent]   || nil

      no_parent_exception if parent_required && parent.nil?

      path = "#{object_class.path}?page=#{page}&per_page=#{per_page}"
      path = path_with_parent(path, parent) if parent

      unless filters.keys.empty?
        query = filters.map { |key, value| "filter=#{key}==#{value}" }.join("&")

        path += "&#{query}"
      end

      response = Cakemail.get path

      instantiate_object_list(response["data"], parent) unless response.nil?
    end

    # Returns total count
    #
    # @return Integer
    #
    # @example
    #           total_contacts = Cakemail::Contact.count
    def self.count(options = {})
      parent = get_parent(options)

      path = "#{object_class.path}?page=1&per_page=1&with_count=true"
      path = path_with_parent(path, parent) if parent

      response = Cakemail.get path

      response["pagination"]["count"] unless response.nil?
    end

    # Yields each batch of records that was found
    #
    # @param block [Block]
    #
    # @example
    #           total_contacts = Cakemail::Contact.count
    def self.find_in_batches(options = {}, &block)
      total = count(options)

      per_page = options[:per_page] || 50
      page = 1

      loop do
        list(options.merge(page: page, per_page: per_page)).each do |object|
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
    def self.create(params, options = {})
      parent = get_parent(options)

      no_parent_exception if parent_required && parent.nil?

      path = object_class.path
      path = path_with_parent(path, parent) if parent

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
    def delete(options = {})
      parent = get_parent(options)

      path = "#{self.class.object_class.path}/#{id}"
      path = self.class.path_with_parent(path, parent) if parent

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
    def update(params, options = {})
      parent = get_parent(options)

      path = "#{self.class.object_class.path}/#{id}"
      path = self.class.path_with_parent(path, parent) if parent

      response = Cakemail.patch path, params.to_json

      return response unless self.class.response_ok?(response) && response["updated"]

      self.class.instantiate_object(response["data"]) unless response.nil?
    end

    # Archive Cakemail object and return it
    #
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           list = Cakemail::List.find(1)
    #           list.archive
    def archive(options = {})
      parent = get_parent(options)

      path = "#{self.class.object_class.path}/#{id}/archive"
      path = self.class.path_with_parent(path, parent) if parent

      response = Cakemail.post path, {}.to_json

      return response unless self.class.response_ok?(response) && response["archived"]

      self.class.instantiate_object(response) unless response.nil?
    end

    # Unarchive Cakemail object and return it
    #
    # @return [List, Contact, Campaign, Tags]
    #
    # @example
    #           list = Cakemail::List.find(1)
    #           list.unarchive
    def unarchive(options = {})
      parent = get_parent(options)

      path = "#{self.class.object_class.path}/#{id}/unarchive"
      path = self.class.path_with_parent(path, parent) if parent

      response = Cakemail.post path, {}.to_json

      return response unless self.class.response_ok?(response) && !response["archive"]

      self.class.instantiate_object(response) unless response.nil?
    end

    def self.get_parent(options = {})
      options[:parent] || nil
    end

    def get_parent(options = {})
      @parent || self.class.get_parent(options)
    end

    def self.no_parent_exception
      raise NoParentError
    end

    def self.parent_required
      false
    end

    def self.path_with_parent(path, parent)
      "#{parent.class.path}/#{parent.id}/#{path}"
    end

    def self.response_ok?(response)
      [200, 201].include?(response["status_code"])
    end

    def initialize(options = {})
      @id = options["id"]
    end

    def self.object_class; end

    def self.instantiate_object_list(json, parent = nil)
      json.map { |json_object| instantiate_object(json_object, parent) }
    end

    def self.instantiate_object(json, parent = nil)
      object = object_class.new json

      object.parent = parent unless parent.nil?

      object
    end

    def respond_to?(method_name)
      attr = "@#{method_name}"

      return super if method_name.match(/[?!]$/) || !instance_variable_defined?(attr)

      true
    end
  end
end
