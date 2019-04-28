require_relative "./scraper.rb"
require_relative "./brewery.rb"
require_relative "./style.rb"

class BeerAdvocate::Beer
  attr_accessor :name, :brewery, :style, :abv, :review_count, :score, :name_url, :brewery_url, :style_url
  attr_reader :brewery, :style
  
  def brewery=(brewery)
    new_brewery = BeerAdvocate::Brewery.new(brewery)
    @brewery = new_brewery
    new_brewery.add_beer(self)
  end
  
  def style=(style)
    new_style = BeerAdvocate::Style.new(style)
    @style = new_style
    new_style.add_beer(self)
  end
  
  def brewery_url=(brewery_url)
    self.brewery.brewery_url = brewery_url
  end
  
  def style_url=(style_url)
    self.style.style_url = style_url
  end
  
  @@all = []
  
  def initialize(beer_hash)
    beer_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end
  
  def self.create_from_collection(beers_array)
    beers_array.each do |beer_hash|
      BeerAdvocate::Beer.new(beer_hash)
    end
  end
  
  def self.all
    @@all
  end
end

BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)

binding.pry