require_relative './beer.rb'
require_relative './scraper.rb'
require_relative './brewery.rb'

class BeerAdvocate::CLI
  def welcome
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "Welcome to the Beer Advocate CLI! At any time, type 'exit' to quit the program.".yellow.bold
    puts " "
    puts " 1. Browse by beer  || 3. Search by beer"
    puts " 2. Browse by style || 4. Search by brewery"
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
  end
  
  def take_input
    input = gets.strip
    if input == "exit"
      puts " - - - - - - - - - - -".light_blue
      puts "Goodbye!"
      puts " - - - - - - - - - - -".light_blue
    else
      input
    end
  end
  
  def show_beers_table
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "Choose a range: | 1   - Most popular  ||".yellow.bold
    puts "                | 250 - Least popular ||".yellow.bold
    puts " "
    puts "1. 1-50 | 2. 51-100 | 3. 101-150 | 4. 151-200 | 5. 201-250"
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    
    case take_input
    when "1"
      beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)[0..49]
    when "2"
      beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)[50..99]
    when "3"
      beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)[100..149]
    when "4"
      beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)[150..199]
    when "5"
      beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)[200..249]
    end
    
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "Type a beer name for more info.".yellow.bold
    puts " "
    puts "Name | ABV | Score | Review count".bold
    puts " "
    beers.each do |beer|
      puts "#{beer[:name]} | #{beer[:abv]} | #{beer[:score]} | #{beer[:review_count]}"
    end
    puts " "
    puts "Name | ABV | Score | Review count".bold
    puts " "
    puts "Type a beer name for more info.".yellow.bold
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
  end
    
  
  def show_beer(beer)
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    find_beer = beers.find do |listed_beer|
      listed_beer[:name].downcase == beer.downcase
    end
    beer_page_details = BeerAdvocate::Scraper.scrape_name_page(find_beer[:name_url])
    
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "#{find_beer[:name]}".yellow.bold
    puts " "
    puts "Brewery: #{find_beer[:brewery]}   ||   Style: #{find_beer[:style]}   ||   ABV: #{find_beer[:abv]}".bold
    puts "Score: #{find_beer[:score]}   ||   Review count: #{find_beer[:review_count]}".bold
    puts " "
    puts "1. Top reviews | 2. Brewery details | 3. Style details".light_blue.bold
    puts "Choose an option above.".yellow.bold
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    case take_input
    when "1"
      reviews = beer_page_details[:top_reviews]
      puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
      puts " "
      reviews.each do |review|
        puts "#{review}"
        puts " "
        puts "- - - - - - - - - - - - - - - - - - - - ".light_blue
        puts " "
      end
    when "2"
      brewery_beers = BeerAdvocate::Brewery.find_brewery(find_beer[:brewery]).beers
      brewery_beers.each do |beer|
        puts "- - - - - - - - - -".light_blue
        puts "#{brewery_beers.index(beer) + 1}. #{beer.name}"
        puts "- - - - - - - - - -".light_blue
      end
    when "3"
      show_style(take_input)
    end
  end
  
  def show_styles_list
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    styles = beers.collect do |beer|
      beer[:style]
    end
    styles.uniq!
    styles.sort!
    
    puts "Choose a style below."
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
    puts "Press '1' for a list of beers of this style."
  end
  
  def show_brewery(brewery)
    beers = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    find_brewery = beers.find do |listed_beer|
      listed_beer[:brewery].downcase == brewery.downcase
    end
    brewery_page_details = BeerAdvocate::Scraper.scrape_brewery_page(find_brewery[:brewery_url])
    
    puts "- - - - - - - - - - - - - - - - - - - - - - - - - -".light_blue
    puts "#{find_brewery[:brewery]}".yellow.bold
    puts " "
    puts "#{brewery_page_details[:type]}"
    puts " "
    puts "#{brewery_page_details[:address]}"
    puts " "
    puts "#{brewery_page_details[:phone_number]}"
    puts " "
    puts "#{brewery_page_details[:website]}"
    puts " "
    puts "Press '1' for a list of beers from this brewery.".yellow.bold
    puts "- - - - - - - - - - - - - - - - - - - - - - - - - -".light_blue
    
    case take_input
    when "1"
      puts "- - - - - - - - - - - - - - -".light_blue
      puts "#{find_brewery[:brewery]}".yellow.bold
      puts " "
      puts "#{BeerAdvocate::Brewery}"
    end
  end
  
  def beer_table_interaction
    show_beers_table
    show_beer(take_input)
  end
  
  def run
    welcome
    case take_input
    when "1"
      beer_table_interaction
    when "2"
      show_styles_list
    when "3"
      until show_beer(take_input)
        puts "Invalid input; try again:"
      end
      show_beer(take_input)
    when "4"
      until show_brewery(take_input)
        puts "Invalid input; try again:"
      end
      show_brewery(take_input)
    end
  end
end