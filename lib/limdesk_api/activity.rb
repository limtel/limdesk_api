module LimdeskApi

  class Activity < RecursiveOpenStruct

    def self.create(params)
      response = LimdeskApi.create(:object=>:activity , :params=>params)
      Activity.new response
    end

    def self.all
      query_options = { page: 1, object: :activity }
      results = {}
      activities = []
      loop do
        unless results[:total_pages].nil?
          raise StopIteration if results[:total_pages] == results[:page]
        end
        results = LimdeskApi.get_many(query_options)
        query_options[:page] += 1
        activities+=results[:objects].map { |x| Activity.new x }
      end
      activities
    end

    def ok?
      error == true ? false : true
    end

  end
  
end