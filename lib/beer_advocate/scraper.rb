class BeerAdvocate::Scraper
  BEER_ADVOCATE_URL = "https://www.beeradvocate.com/lists/popular/"

  @@scraped_urls = []
  
  def self.scraped_urls
    @@scraped_urls
  end
  
  def self.find_url(url)
    self.scraped_urls.find do |scraped_url_hash| 
      scraped_url_hash.keys.to_s.split('"')[1] == url
    end
  end
  
  def self.find_url_details(url)
    found_url = self.scraped_urls.find do |scraped_url_hash| 
      scraped_url_hash.keys.to_s.split('"')[1] == url
    end
    found_url[url.to_sym]
  end

  def self.scrape_list_page
    puts "SCRAPING #{BEER_ADVOCATE_URL} ************"
    
    html = open(BEER_ADVOCATE_URL)
    beer_list_page = Nokogiri::HTML(html)
    
    beer_hashes = []
    
    beer_list = beer_list_page.css("tr")[2..-1]

    beer_list.each do |beer|
      beer_hash = {}
      beer_hash[:name] = beer.css("td")[1].css("a")[0].text
      beer_hash[:brewery] = beer.css("td")[1].css("a")[1].text
      beer_hash[:style] = beer.css("td")[1].css("a")[2].text
      beer_hash[:abv] = beer.css("td")[1].css("span").text.split('|')[1].strip
      beer_hash[:review_count] = beer.css("td")[2].text
      beer_hash[:score] = beer.css("td")[3].text
      beer_hash[:name_url] = "http://www.beeradvocate.com#{beer.css("td")[1].css("a")[0]["href"]}?sort=topr&start=0"
      beer_hash[:brewery_url] = "http://www.beeradvocate.com#{beer.css("td")[1].css("a")[1]["href"]}"
      beer_hash[:style_url] = "http://www.beeradvocate.com#{beer.css("td")[1].css("a")[2]["href"]}"
      beer_hashes << beer_hash
    end
    
    beer_hashes
  end

  def self.scrape_name_page(name_url)
    puts "SCRAPING #{name_url} ************"
    
    html = open(name_url)
    name_page = Nokogiri::HTML(html)
    
    info_box = name_page.css("div#info_box.break")
    reviews = name_page.css("div#rating_fullview_content_2")
    
    name_hash = {}
    name_hash[:description] = info_box.text.split("\n\n")[7..-1].join("\n\n").strip
    name_hash[:pdev] = name_page.css("span.ba-pdev").text.strip
    
    name_hash[:top_reviews] = []
    reviews.each do |review|
      review.css("br").each{|br| br.replace("\n")}
      review_text = review.text.split("\n\n")[1]
      name_hash[:top_reviews] << review_text
    end
    
    name_hash[:top_reviews] = name_hash[:top_reviews][1..9]
    name_hash[:top_reviews].delete_if {|review| review.length < 40}
    
    scraped_url_hash = {}
    scraped_url_hash[name_url.to_sym] = name_hash
    self.scraped_urls << scraped_url_hash
    
    name_hash
  end
  
  def self.scrape_brewery_page(brewery_url)
    puts "SCRAPING #{brewery_url} ************"
    
    html = open(brewery_url)
    brewery_page = Nokogiri::HTML(html)
    
    info_box = brewery_page.css("div#info_box.break")
    info_box.css("br").each{|br| br.replace("\n")}
    info_array = info_box.text.split("\n\n\n\n")
    jumbled_phone_number = info_array[2].split("\n\n")[1]
    
    brewery_hash = {}
    brewery_hash[:type] = info_array[1]
    brewery_hash[:address] = info_array[2].split("\n\n")[0]
    brewery_hash[:phone_number] = jumbled_phone_number.split("|")[0].strip
    brewery_hash[:website] = jumbled_phone_number.split("\n")[1].strip
    
    scraped_url_hash = {}
    scraped_url_hash[brewery_url.to_sym] = brewery_hash
    self.scraped_urls << scraped_url_hash
    
    brewery_hash
  end
  
  def self.scrape_style_page(style_url)
    puts "SCRAPING #{style_url} ************"
    
    html = open(style_url)
    style_page = Nokogiri::HTML(html)
    
    description_box_array = style_page.css("div#ba-content div").text.split("\n")
    jumbled_details = description_box_array[2].split("|")
    
    style_hash = {}
    style_hash[:description] = description_box_array[1].strip
    style_hash[:abv] = jumbled_details[0].strip
    style_hash[:ibu] = jumbled_details[1].strip
    style_hash[:glassware] = jumbled_details[2].strip
    
    scraped_url_hash = {}
    scraped_url_hash[style_url.to_sym] = style_hash
    self.scraped_urls << scraped_url_hash
    
    style_hash
  end
end