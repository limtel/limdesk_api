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
  end
end
