module LimdeskApi
  # Limdesk Activity
  class Activity < LimdeskObject
    NOT_IMPLEMENTED = 'activity currently does not support this call'
    # Creates a new Activity
    #
    # @param [Hash] params the options to create an activity with
    # @option params [String] :content activity content
    # @option params [String] :client_id client (optional)
    #
    # @return [LimdeskApi::Activity]
    def self.create(params)
      super
    end

    def self.get(*)
      fail Activity::NOT_IMPLEMENTED
    end

    def refresh!
      fail Activity::NOT_IMPLEMENTED
    end

    def delete!
      fail Activity::NOT_IMPLEMENTED
    end
  end
end
