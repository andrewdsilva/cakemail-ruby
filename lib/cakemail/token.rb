module Cakemail
  # @attr [String]   access_token
  # @attr [String]   refresh_token
  # @attr [Integer]  expires_in
  # @attr [String]   token_type
  class Token < Base
    attr_accessor :access_token, :refresh_token, :expires_in, :token_type

    # Create new token with username and password provided
    #
    # @param username  [String]
    # @param password  [String]
    # @return [Token]
    #
    # @example
    #           token = Cakemail::Token.create('toto', 'password123')
    def self.create(username = nil, password = nil)
      path = object_class.path

      response = Cakemail.post path, authentication_params(username, password), { "content-type": "application/x-www-form-urlencoded" }

      if response_ok? response
        instantiate_object response
      else
        response
      end
    end

    def self.path
      "token"
    end

    def self.object_class
      Cakemail::Token
    end

    def initialize(options = {})
      super(options)

      @access_token  = options["access_token"]
      @refresh_token = options["refresh_token"]
      @expires_in    = options["expires_in"]
      @token_type    = options["token_type"]
    end

    def self.authentication_params(username, password)
      username = ENV["CAKEMAIL_USERNAME"] if username.nil?
      password = ENV["CAKEMAIL_PASSWORD"] if password.nil?

      {
        grant_type: "password",
        scopes: "user",
        username: username,
        password: password
      }
    end
  end
end
