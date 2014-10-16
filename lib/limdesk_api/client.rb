module LimdeskApi

  class Client < RecursiveOpenStruct

    def self.get(id)
      response = LimdeskApi.get_one(:object=>:client, :id=>id)
      response ? Client.new(response) : nil
    end

    def self.create(params)
      response = LimdeskApi.create(:object=>:client, :params=>params)
      Client.new response
    end

    def self.all
      query_options = { page: 1, object: :client }
      results = {}
      clients = []
      loop do
        unless results[:total_pages].nil?
          raise StopIteration if results[:total_pages] == results[:page]
        end
        results = LimdeskApi.get_many(query_options)
        query_options[:page] += 1
        clients+=results[:objects].map { |x| Client.new x }
      end
      clients
    end

    def ok?
      error == true ? false : true
    end

    def refresh!
      self.marshal_load(Client.get(self['id']).marshal_dump)
    end

    def delete!
      response = LimdeskApi.delete( id: self.id, object: :client )
      return not(response[:error])
    end

  end
end