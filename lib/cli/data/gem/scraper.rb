require "pry"
require "nokogiri"
require "open-uri"

class Scraper

  def self.scrape_list_page
    html = open("https://www.beeradvocate.com/lists/popular/")
    beer_list_page = Nokogiri::HTML(html)
    
    beer_hashes = []
    
    beer_list = beer_list_page.css("tr")[2..-1]

    beer_list.each do |beer|
      beer_hash = {}
      beer_hash[:name] = beer.css("td")[1].css("a")[0].text
      beer_hash[:brewery] = beer.css("td")[1].css("a")[1].text
      beer_hash[:style] = beer.css("td")[1].css("a")[2].text
      beer_hash[:abv] = beer.css("td")[1].css("span").text.split('|')[1].strip
      beer_hash[:ratings] = beer.css("td")[2].text
      beer_hash[:score] = beer.css("td")[3].text
      beer_hash[:name_url] = "http://www.beeradvocate.com#{beer.css("td")[1].css("a")[0]["href"]}"
      beer_hash[:brewery_url] = "http://www.beeradvocate.com#{beer.css("td")[1].css("a")[1]["href"]}"
      beer_hash[:style_url] = "http://www.beeradvocate.com#{beer.css("td")[1].css("a")[2]["href"]}"
      beer_hashes << beer_hash
    end
    
    beer_hashes
  end

  def self.scrape_name_page(name_url)
    html = open(name_url)
    name_page = Nokogiri::HTML(html)
    
    info_box = name_page.css("div#info_box.break")
    
    name_hash = {}
    name_hash[:description] = info_box.text.split("\n\n")[7..-1].join("\n\n")
  end
  
  def self.scrape_brewery_page(brewery_url)
    html = open(brewery_url)
    brewery_page = Nokogiri::HTML(html)
    
    info_box = brewery_page.css("div#info_box.break")
    
    brewery_hash = {}
    brewery_hash[:type] = info_box.text.split("\n\n")[2]
    
    # contact_info is too jumbled
    contact_info = info_box.text.split("\n\n")[3]
  end
end

binding.pry