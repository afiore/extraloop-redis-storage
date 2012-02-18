module ExtraLoop
  class ScraperBase
    def set_storage(title, model=nil)
      log_session!(title)

      model ||= self.class.to_s.gsub(/Scraper/,'Data').downcase.to_sym

      @model = model_klass = model && model.respond_to?(:new) || ExtraLoop::Storage::DatasetFactory.new(model.to_sym, @extractor_args.map(&:first)).get_class

      on :data do |results|
        # TODO: find a way to avoid calling send in the scraper object
        results = results.map { |result| model_klass && @scraper.send(:instanciate_model, result) || result }
        binding.pry
        #TODO: will this block given work?
        block_given? && yield(results) || results.each { |result| result.save if result.respond_to?(:save) && result.id.nil? }
      end
    end

    protected
    # Creates a scraping session
    def log_session!(title="")
      @session ||= ExtraLoop::Storage::ScrapingSession.create :title => title
    end

    # Converts extracted records into instances of the dataset model specified as the first argument
    # of #set_storage

    def instanciate_model(record)
      record_hash = record.respond_to?(:marshal_dump) ? record.marshal_dump : record
      attrs = {:session_id => @session.id }.merge(record_hash)
      @model.new(attrs)
    end
  end
end
