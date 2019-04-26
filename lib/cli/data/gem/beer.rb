require "pry"
require "nokogiri"
require "open-uri"

require_relative "./scraper.rb"

class Beer
  attr_accessor :name, :brewery, :style, :abv, :review_count, :score, :name_url, :brewery_url, :style_url
  
  @@all = []
  
  
end