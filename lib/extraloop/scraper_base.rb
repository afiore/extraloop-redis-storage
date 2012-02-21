class ExtraLoop::ScraperBase
  attr_reader :session

  def set_storage(model, title=nil)
    collection_name = "#{Time.now.to_i} #{model.to_s} Dataset"
    title ||= collection_name
    log_session! title

    @model = model_klass = model.respond_to?(:new) && model || ExtraLoop::Storage::DatasetFactory.new(model.to_sym, @extractor_args.map(&:first)).get_class

    on :data do |results|
      results = results.map { |result| @scraper.send(:instanciate_model, result) }
      block_given? && yield(results) || results.each { |result| result.save if result.respond_to?(:save) }
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
    attrs = {:session => @session }.merge(record_hash)
    @model.new(attrs)
  end
end
