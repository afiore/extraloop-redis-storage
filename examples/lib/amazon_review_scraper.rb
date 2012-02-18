class AmazonReviewScraper < ExtraLoop::ScraperBase
  def initialize(review_id)
    url = "http://www.amazon.co.uk/product-reviews/#{review_id}/ref=dp_top_cm_cr_acr_txt?ie=UTF8&showViewpoints=1"
    super(url)

    loop_on("#productReviews span[class^='swSprite s_star']") do |nodes|
      nodes.map { |node| node.parent.parent }
    end

    extract(:rank, "span[class^=swSprite]", :title)  { |title| title && title.match(/^(\d)/) && $1.to_i }
    extract(:title, "b")
    extract(:date, "nobr") { |date| Date.parse(date.text) if date }
  end
end
