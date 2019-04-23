require 'pry'
require 'nokogiri'
require 'open-uri'

class Scraper

  def self.scrape_list_page
    html = open('https://www.beeradvocate.com/lists/popular/')
    beer_list_page = Nokogiri::HTML(html)
    
    beer_hashes = []
    
    beer_list = beer_list_page.css("tr")[2..-1]

    beer_list.each do |beer|
      beer_hash = {:name => nil, :brewery => nil, :style => nil, :abv => nil, :ratings => nil, :score => nil, :details_url => nil}
      beer_hash[:name] = beer.css("td")[1].css("a")[0].text
      beer_hash[:brewery] = 
      beer_hash[:style] = 
      beer_hash[:abv] =
      beer_hash[:ratings] =
      beer_hash[:score] =
      beer_hash[:details_url] = beer.css("a").attribute("href").value
      beer_hashes << beer_hash
    end
    
    beer_hashes
  end

  # def self.scrape_profile_page(profile_url)
  #   html = open(profile_url)
  #   profile_page = Nokogiri::HTML(html)
    
  #   user_profile = {}
   
  #   social_links = profile_page.css("div.social-icon-container").css("a").collect do |site|
  #     site["href"]
  #   end
    
  #   social_links.each do |social_link|
  #     if social_link.scan(/\w+/)[1] != "www"
  #       site = social_link.scan(/\w+/)[1].to_sym
  #     else
  #       site = social_link.scan(/\w+/)[2].to_sym
  #     end
  #     if [:twitter, :linkedin, :github].include?(site)
  #       user_profile[site] = social_link
  #     else
  #       user_profile[:blog] = social_link
  #     end
  #   end
    
  #   user_profile[:profile_quote] = profile_page.css("div.profile-quote").text
  #   user_profile[:bio] = profile_page.css("div.bio-block.details-block").css("div.description-holder").text.strip

  #   user_profile
  # end
end

binding.pry