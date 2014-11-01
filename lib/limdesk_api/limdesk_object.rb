module LimdeskApi
  # This class represents a LimdeskAPI object.
  # Ohter classes, like Ticket, Sale and Client, inherit from it.
  class LimdeskObject < RecursiveOpenStruct
    # Gets a Object form LimdeskAPI by it's ID
    #
    # @param [Integer] id requested object's id
    #
    # @return [LimdeskApi::Ticket]
    # @return [LimdeskApi::Client]
    # @return [LimdeskApi::Sale]
    def self.get(id)
      response = LimdeskApi.get_one(object: self.object_symbol, id: id)
      response ? self.new(response) : nil
    end

    # Creates an object by LimdeskAPI
    #
    # @param [Hash] params new object data (depending on object's type)
    #
    # @return [LimdeskApi::Ticket]
    # @return [LimdeskApi::Client]
    # @return [LimdeskApi::Sale]
    def self.create(params)
      response = LimdeskApi.create(object: self.object_symbol, params: params)
      self.new response
    end

    # Gets all objects of a type from LimdeskAPI
    #
    # @return [Array<LimdeskApi::Ticket>]
    # @return [Array<LimdeskApi::Client>]
    # @return [Array<LimdeskApi::Sale>]
    # @return [Array<LimdeskApi::Activity>]
    def self.all
      LimdeskApi.get_all(self.object_symbol).map { |obj| self.new obj }
    end

    # Helper - get class name as a symbol
    # @return [Symbol]
    def self.object_symbol
      self.name.downcase.split(':').last.to_sym
    end

    # Force object to refresh itself from LimdeskAPI
    #
    # @return [LimdeskApi::Ticket]
    # @return [LimdeskApi::Client]
    # @return [LimdeskApi::Sale]
    def refresh!
      self.marshal_load(self.class.get(self['id']).marshal_dump)
    end

    # Delete an object by LimdeskAPI
    #
    # @return [Boolean]
    def delete!
      LimdeskApi.delete(id: self['id'], object: object_symbol)
    end

    # Helper - get class name as a symbol
    # @return [Symbol]
    def object_symbol
      self.class.name.downcase.split(':').last.to_sym
    end
  end
end
