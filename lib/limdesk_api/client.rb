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

    # Gets a Client by property
    #
    # @param [String] action search type
    # @param [String] query search data
    #
    # @return [LimdeskApi::Client]
    def self.get_by(action, query)
      response = LimdeskApi.get_one object: object_symbol,
                                    action: action,
                                    query: query
      response ? new(response) : nil
    end

    # Gets a Client by e-mail
    #
    # @param [String] email find by e-mail
    #
    # @return [LimdeskApi::Client]
    def self.get_by_email(email)
      get_by('get_by_email', email)
    end

    # Gets a Client by phone
    #
    # @param [String] phone find by phone
    #
    # @return [LimdeskApi::Client]
    def self.get_by_phone(phone)
      get_by('get_by_phone', phone)
    end

    # Gets a Client by nippesel
    # (it's taxid, document_id or other government issued unique id number)
    #
    # @param [String] phone find by phone
    #
    # @return [LimdeskApi::Client]
    def self.get_by_nippesel(nippesel)
      get_by('get_by_nippesel', nippesel)
    end

    # Gets a Client by outside_client_id
    #
    # @param [String] outside_client_id find by outside_client_id
    #
    # @return [LimdeskApi::Client]
    def self.get_by_outside_client_id(outside_client_id)
      get_by('get_by_outside_id', outside_client_id)
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
