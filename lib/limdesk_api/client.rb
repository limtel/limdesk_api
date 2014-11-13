module LimdeskApi
  # Client
  class Client < LimdeskObject
    # Creates a new Client
    #
    # @param [Hash] params the options to create a client with
    # @option params [String] :name client's name
    # @option params [String] :nippesel unique ID like VATID, passport
    # @option params [String] :phone client's phone number
    # @option params [String] :email client's email address
    # @option params [String] :address client's personal/company address
    #
    # @return [LimdeskApi::Client]
    def self.create(params)
      super
    end

    # Gets a Client by e-mail
    #
    # @param [String] email find by e-mail
    #
    # @return [LimdeskApi::Client]
    def self.get_by_email(email)
      response = LimdeskApi.get_one object: object_symbol,
                                    action: 'get_by_email',
                                    query: email
      response ? new(response) : nil
    end

    # Gets a Client by phone
    #
    # @param [String] phone find by phone
    #
    # @return [LimdeskApi::Client]
    def self.get_by_phone(phone)
      response = LimdeskApi.get_one object: object_symbol,
                                    action: 'get_by_phone',
                                    query: phone
      response ? new(response) : nil
    end

    # updates a client
    #
    # @param [Hash] params new client data
    #
    # @return [LimdeskApi::Client]
    def update(params)
      LimdeskApi.put object: object_symbol,
                     params: params,
                     id: id
    end
  end
end
