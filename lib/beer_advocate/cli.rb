require_relative './beer.rb'
require_relative './scraper.rb'

class BeerAdvocate::CLI
  def welcome
    puts "Welcome to the Beer Advocate CLI! At any time, type 'menu' to return to this menu or 'back' to return to the previous page."
    puts " 1. Browse by beer  | 2. Search by beer"
    puts " 2. Browse by style | 4. Search by brewery"
  end
  
  def take_input
    input = gets.strip
  end
  
  def show_beers_table
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    puts "Review Count | Name         | Score | ABV"
    beers.each do |beer|
      puts "#{beer[:review_count]} | #{beer[:name]} | #{beer[:review_count]} | #{beer[:score]} | #{beer[:abv]}"
    end
  end
  
  def show_styles_table
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    styles = beers.collect do |beer|
      beer[:style]
    end
    styles.uniq!
    styles.sort!
    styles.each do |style|
      puts "#{styles.index(style)}. #{style}"
    end
  end
end