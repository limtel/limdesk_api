module LimdeskApi

  class Ticket < RecursiveOpenStruct

    CLOSE_TYPES = {
      rejected: 2,
      resolved: 1 
    }

    MEDIA_TYPES = {
      mail: 1,
      chat: 2,
      phone: 3,
      other: 4,   
    }

    ANSWER_TYPES = {
      pub: 0,
      priv: 1
    }

    def self.get(no)
      response = LimdeskApi.get_one(:object=>:ticket, :id=>no)
      response ? Ticket.new(response) : nil
    end

    def self.create(params)
      raise "BadMediaType" unless Ticket::MEDIA_TYPES.keys.include?(params[:reported_by])
      params["reportedBy"] = Ticket::MEDIA_TYPES[params.delete(:reported_by)]
      response = LimdeskApi.create(:object=>:ticket, :params=>params)
      Ticket.new response
    end

    def self.all
      query_options = { page: 1, object: :ticket }
      results = {}
      tickets = []
      loop do
        unless results[:total_pages].nil?
          raise StopIteration if results[:total_pages] == results[:page]
        end
        results = LimdeskApi.get_many(query_options)
        query_options[:page] += 1
        tickets+=results[:objects].map { |x| Ticket.new x }
      end
      tickets
    end

    def ok?
      error == true ? false : true
    end

    def refresh!
      self.marshal_load(Ticket.get(self['number']).marshal_dump)
    end

    def close(params)
      raise "BadCloseType" unless Ticket::CLOSE_TYPES.keys.include?(params[:type])
      raise "NoContentGiven" unless params[:content]
      response = LimdeskApi.put( id: self.number,
                              object: :ticket,
                              action: :close,
                              params: { content: params[:content], type: Ticket::CLOSE_TYPES[params[:type]] } )
      refresh!
      return not(response[:error])
    end

    def reopen
      response = LimdeskApi.put( id: self.number,
                              object: :ticket,
                              action: :reopen,
                              params: {} )
      refresh!
      return not(response[:error])
    end  

    def answer(params)
      raise "BadAnswerType" unless Ticket::ANSWER_TYPES.keys.include?(params[:answer_type])
      params["type"] = Ticket::ANSWER_TYPES[params.delete(:answer_type)]
      response = LimdeskApi.post_simple(  id: self.number,
                                       object: :ticket,
                                       action: :answer,
                                       params: params )
      refresh!      
      return not(response[:error])
    end

  end
end