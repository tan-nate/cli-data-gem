require "pry"
require "nokogiri"
require "open-uri"

require_relative "./scraper.rb"

class Beer
  attr_accessor :name, :brewery, :style, :abv, :review_count, :score, :name_url, :brewery_url, :style_url
  
  @@all = []
  
  def initialize(beer_hash)
    beer_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end
  
  def self.create_from_collection(beers_array)
    beers_array.each do |beer_hash|
      Beer.new(beer_hash)
    end
  end
  
  def self.all
    @@all
  end
end

Beer.create_from_collection(Scraper.scrape_list_page)

binding.pry