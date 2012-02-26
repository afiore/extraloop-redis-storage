class AmazonReview < ExtraLoop::Storage::Record
  attribute :title
  attribute :rank
  attribute :date

  def validate
    assert (0..5).include?(rank.to_i), "Rank not in range"
  end
end
