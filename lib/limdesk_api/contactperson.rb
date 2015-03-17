module LimdeskApi
  # ContactPerson
  class Contactperson < LimdeskObject
    NOT_IMPLEMENTED = 'contactperson currently does not support this call'
    # Creates a new contact person
    #
    # @param [Hash] params the options to create a contact person with
    # @option params [String] :name contact person name
    # @option params [String] :phone contact person phone number
    # @option params [String] :email contact person email address
    # @option params [Integer] :client_id client's id (parent)
    #
    # @return [LimdeskApi::Contactperson]
    def self.create(params)
      super
    end

    # updates a contact person
    #
    # @param [Hash] params new contact person data
    #
    # @return [LimdeskApi::Contactperson]
    def update(params)
      LimdeskApi.put object: object_symbol,
                     params: params,
                     id: id
    end

    def all
      fail Activity::NOT_IMPLEMENTED
    end
  end
end
