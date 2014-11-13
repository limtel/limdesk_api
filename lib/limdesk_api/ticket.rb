module LimdeskApi
  # Client's ticket
  class Ticket < LimdeskObject
    # map close reason symbols to LimdeskAPI's ids
    CLOSE_TYPES = {
      rejected: 2,
      resolved: 1
    }
    # map media symbols to LimdeskAPI's ids
    MEDIA_TYPES = {
      mail: 1,
      chat: 2,
      phone: 3,
      other: 4
    }
    # map answer symbols to LimdeskAPI's ids
    ANSWER_TYPES = {
      pub: 0,
      priv: 1
    }

    # Creates a new Ticket
    #
    # @param [Hash] params the options to create a ticket with
    # @option params [Symbol] :reported_by media :mail, :chat, :phone, :other
    # @option params [String] :title ticket's title
    # @option params [String] :content ticket's content
    # @option params [Integer] :client_id ticket's client id
    #
    # @return [LimdeskApi::Ticket]
    def self.create(params)
      fail 'BadMediaType' unless Ticket::MEDIA_TYPES.keys.include?(params[:reported_by])
      params['reportedBy'] = Ticket::MEDIA_TYPES[params.delete(:reported_by)]
      super
    end

    # Refreshes the object from the server
    # @return [LimdeskApi::Ticket]
    def refresh!
      marshal_load(Ticket.get(self['number']).marshal_dump)
    end

    # Closes a ticket
    #
    # @param [Hash] params the options to colose ticket with
    # @option params [Symbol] :type :rejected or :resolved
    # @option params [String] :content comment before closing
    #
    # @return [Boolean]
    def close(params)
      fail 'BadCloseType' unless Ticket::CLOSE_TYPES.keys.include?(params[:type])
      fail 'NoContentGiven' unless params[:content]
      response = LimdeskApi.put(
        id: self['number'],
        object: :ticket,
        action: :close,
        params: {
          content: params[:content],
          type: Ticket::CLOSE_TYPES[params[:type]] })
      refresh!
      response
    end

    # Reopens a closed ticket
    #
    # @return [Boolean]
    def reopen
      response = LimdeskApi.put(
        id: number,
        object: :ticket,
        action: :reopen,
        params: {})
      refresh!
      response
    end

    # Answeres a ticket
    #
    # @param [Hash] params the options to create a answer with
    # @option params [Symbol] :answer_type :priv comment or a :pub answer
    # @option params [String] :content answer or content body
    #
    # @return [Boolean]
    def answer(params)
      fail 'BadAnswerType' unless Ticket::ANSWER_TYPES.keys.include?(params[:answer_type])
      params['type'] = Ticket::ANSWER_TYPES[params.delete(:answer_type)]
      response = LimdeskApi.post_simple(
        id: number,
        object: :ticket,
        action: :answer,
        params: params)
      refresh!
      response
    end
  end
end
