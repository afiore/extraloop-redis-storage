class ScraperBase
  def set_storage(model, &block)
    log_session! if @request_count === 0

    @model = model.respond_to?(:new) ? 
      model : ExtraLoop::Storage::DatasetFactory.new(model.to_sym, @extractor_args.map &:first)

    on(:data, proc { |results|
      # TODO::results should be first converted in instances of the dataset class
      block && block.call(results) || results.each do |results|
      end
    })
  end

  protected
  def log_session!
    
  end
end
