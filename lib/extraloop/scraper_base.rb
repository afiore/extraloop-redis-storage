module ExtraLoop
  class ScraperBase
    def set_storage(model=nil, title = "", &block)
      log_session!(title) if @request_count === 0
  
      if model
        @model = model.respond_to?(:new) ?
          model : ExtraLoop::Storage::DatasetFactory.new(model.to_sym, @extractor_args.map(&:first)).get_class
      end
  
      on(:data, proc { |results|
        results = results.map { |result| @model && instanciate_model(result) || result }
        block && block.call(results) || results.each(&:save)
      })
    end
  
    protected
  
    # Creates a scraping session
  
    def log_session!(title="")
      @session ||= ExtraLoop::Storage::ScrapingSession.create :title => title
    end
  
    # Converts extracted records into instances of the dataset model specified as the first argument
    # of #set_storage
  
    def instanciate_model(record)
      attrs = {:session => @session }.merge(record.respond_to?(:marshal_dump) ? record.marshal_dump : record)
      @model.new(attrs)
    end
  end
end
