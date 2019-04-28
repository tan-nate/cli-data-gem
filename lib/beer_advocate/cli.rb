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
    puts "Review count | Name | Score | ABV"
    beers.each do |beer|
      puts "#{beer[:review_count]} | #{beer[:name]} | #{beer[:review_count]} | #{beer[:score]} | #{beer[:abv]}"
    end
  end
  
  def show_beer(beer)
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    find_beer = beers.find do |listed_beer|
      listed_beer[:name].downcase == beer.downcase
    end
    beer_page_details = BeerAdvocate::Scraper.scrape_name_page(find_beer[:name_url])
    
    puts "#{find_beer[:name]}"
    puts "Brewery: #{find_beer[:brewery]} | Review count: #{find_beer[:review_count]}"
    puts "Style: #{find_beer[:style]} | Score: #{find_beer[:score]}"
    puts "ABV: #{find_beer[:abv]}"
    puts "1. Top reviews | 2. Brewery details | 3. Style details"
    puts "Choose an option above, or type 'back' or 'menu'"
  end
  
  def show_styles_list
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
  
  def show_style(style)
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    find_style = beers.find do |listed_beer|
      listed_beer[:style].downcase == style.downcase
    end
    style_page_details = BeerAdvocate::Scraper.scrape_style_page(find_style[:style_url])

    puts "#{find_style[:style]}"
    puts "Description: #{style_page_details[:description]}"
    puts "#{style_page_details[:abv]}"
    puts "#{style_page_details[:ibu]}"
    puts "#{style_page_details[:glassware]}"
    puts "Press '1' for a list of beers of this style"
  end
  
  def show_brewery(brewery)
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    find_brewery = beers.find do |listed_beer|
      listed_beer[:brewery].downcase == brewery.downcase
    end
    brewery_page_details = BeerAdvocate::Scraper.scrape_brewery_page(find_brewery[:brewery_url])

    puts "#{find_brewery[:brewery]}"
    puts "#{brewery_page_details[:type]}"
    puts "#{brewery_page_details[:address]}"
    puts "#{brewery_page_details[:phone_number]}"
    puts "#{brewery_page_details[:website]}"
    puts "Press '1' for a list of beers from this brewery"
  end
end