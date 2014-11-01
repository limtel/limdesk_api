module LimdeskApi
  # Client's sales registry
  class Sale < LimdeskObject
    # Creates a new Client's Sale
    #
    # @param [Hash] params the options to create a sale with
    # @option params [String] :client_id client's id
    # @option params [String] :name sales name ("nice shoes")
    # @option params [Float] :price price of one item
    # @option params [DateTime] :sold sales date
    # @option params [DateTime] :expire expiration date (time-limted services)
    #
    # @return [LimdeskApi::Sale]
    def self.create(params)
      super
    end
  end
end
