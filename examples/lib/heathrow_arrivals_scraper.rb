class HeathrowArrivalScraper < ExtraLoop::ScraperBase
  def initialize
    url = "http://www.heathrowairport.com/flight-information/live-flight-arrivals"
    super url

    loop_on("//table[@id='timeTable']/tbody/tr[position() > 2][td]")

    extract :scheduled_time, "td[1]"
    extract :flight_number,  "td[2]"
    extract(:status,         "td[4]")   { |td| td && td.text.strip }
    extract(:origin, "td[3]")           { |td| td && td.text.split(/(\s|\r|\n)VIA(\s|\r|\n)/).map(&:strip).reject(&:empty?) }
    extract(:terminal, "td[5]")         { |terminal| terminal && terminal.text.strip.gsub(/^Terminal\s/,'') }


  end
end
