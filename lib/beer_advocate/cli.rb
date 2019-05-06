require 'pry'

require_relative './beer.rb'
require_relative './scraper.rb'
require_relative './brewery.rb'

class BeerAdvocate::CLI
  attr_accessor :beer_list, :beers, :styles, :reviews, :find_beer, :find_brewery
  
  def initialize
    @beer_list = BeerAdvocate::Beer.create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
  end
  
  def welcome
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    beer_advocate_cli_text = "Beer Advocate CLI".yellow.bold
    puts("Welcome to the " << beer_advocate_cli_text << "! At any time, type 'exit' to quit the program, or 'menu' to return to this menu.")
    puts " "
    puts " 1. Browse by beer  || 3. Search by beer"
    puts " 2. Browse by style || 4. Search by brewery"
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
  end
  
  def take_input
    input = gets.strip.downcase
    if input == "exit"
      puts " - - - - - - - - - - -".light_blue
      puts "Goodbye!"
      puts " - - - - - - - - - - -".light_blue
      exit
    elsif input == "menu"
      run
    else
      input
    end
  end
  
  def show_beers_table_input
    case take_input
    when "1"
      @beers = @beer_list[0..49]
    when "2"
      @beers = @beer_list[50..99]
    when "3"
      @beers = @beer_list[100..149]
    when "4"
      @beers = @beer_list[150..199]
    when "5"
      @beers = @beer_list[200..249]
    else
      puts ""
      puts "Invalid. Please type 1-5:".bold
      show_beers_table_input
    end
  end
  
  def show_beers_table
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "Choose a range: || 1   - Most popular  ".yellow.bold
    puts "                || 250 - Least popular ".yellow.bold
    puts " "
    puts "1. 1-50 | 2. 51-100 | 3. 101-150 | 4. 151-200 | 5. 201-250"
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    
    show_beers_table_input
    
    green_beer = "Name".green.bold
    blue_brewery = "Brewery".light_blue.bold
    abv = abv = " | ABV | "
    bold_rating = "Score /5".red.bold
    the_rest = " | Review count"
    complete_beer = green_beer << " | " << blue_brewery << abv << bold_rating << the_rest
    
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "Type a beer name for more info.".yellow.bold
    puts complete_beer
    puts " "
    puts " "
    @beers.each do |beer|
      green_beer1 = "#{beer[:name]}".green.bold
      blue_brewery1 = "#{beer[:brewery]}".light_blue.bold
      abv1 = " | #{beer[:abv]} | "
      bold_rating1 = "#{beer[:score]}".red.bold
      rest1 = " | #{beer[:review_count]}"
      complete_beer1 = green_beer1 << " | " << blue_brewery1 << abv1 << bold_rating1 << rest1
      puts complete_beer1
      puts " "
    end
    puts " "
    puts complete_beer
    puts "Type a beer name for more info.".yellow.bold
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
  end
    
  def show_beer_input
    case take_input
    when "1"
      @reviews.each do |review|
        puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
        puts "#{review}"
        puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
        puts " "
      end
      puts "Type 'menu':".yellow.bold
      puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
      menu_from_reviews
    when "2"
      show_brewery(find_beer[:brewery])
    when "3"
      show_style(find_beer[:style])
    else
      puts ""
      puts "Invalid. Please type 1-3:".bold
      show_beer_input
    end
  end
  
  def menu_from_reviews
    if take_input != "menu" || take_input != "exit"
        puts ""
        puts "Type menu:".bold
        menu_from_reviews
    end
  end
  
  def show_beer(beer)
    @find_beer = @beer_list.find do |listed_beer|
      listed_beer[:name].downcase == beer.downcase
    end
    if @find_beer == nil
      puts ""
      puts "Invalid. Please type the beer exactly as it appears in the beer list:".bold
      show_beer(take_input)
    end
    
    beer_page_details = BeerAdvocate::Scraper.scrape_name_page(find_beer[:name_url])
    @reviews = beer_page_details[:top_reviews]
    
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    puts "#{find_beer[:name]}".yellow.bold
    puts " "
    puts "Brewery: #{find_beer[:brewery]} || Style: #{find_beer[:style]} || ABV: #{find_beer[:abv]} || Score: #{find_beer[:score]} || Review count: #{find_beer[:review_count]}"
    puts " "
    puts "1. Top reviews | 2. Brewery details | 3. Style details".light_blue.bold
    puts "Choose an option above.".yellow.bold
    puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
    
    show_beer_input
  end
  
  def show_styles_list
    @styles = @beer_list.collect do |beer|
      beer[:style]
    end
    @styles.uniq!
    @styles.sort!
    
    puts "- - - - - - - - - - - - - - - - -".light_blue
    puts "Type a style number:".yellow.bold
    puts " "
    @styles.each do |style|
      puts "#{styles.index(style) + 1}. #{style}"
    end
    puts " "
    puts "Type a style number:".yellow.bold
    puts "- - - - - - - - - - - - - - - - -".light_blue
    
    show_styles_list_input
  end
  
  def show_styles_list_input
    numerized_input = take_input.to_i
    if numerized_input.between?(1, @styles.length)
      show_style(@styles[numerized_input - 1])
    else
      puts ""
      puts "Invalid. Please type a style number:".bold
      show_styles_list_input
    end
  end
  
  def show_style(style)
    beers = BeerAdvocate::Beer.find_or_create_from_collection(BeerAdvocate::Scraper.scrape_list_page)
    find_style = beers.find do |listed_beer|
      listed_beer[:style].downcase == style.downcase
    end
    if find_style == nil
      exit
    end
    style_page_details = BeerAdvocate::Scraper.scrape_style_page(find_style[:style_url])
    
    puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -".light_blue
    puts "#{find_style[:style]}".yellow.bold
    puts " "
    puts "#{style_page_details[:description]}"
    puts " "
    puts "#{style_page_details[:abv]}".bold
    puts "#{style_page_details[:ibu]}".bold
    puts "#{style_page_details[:glassware]}".bold
    puts " "
    puts "Press '1' for a list of beers of this style.".yellow.bold
    puts "- - - - - - - - - - - - - - - - - - - - - -".light_blue
    
    case take_input
    when "1"
      beers = BeerAdvocate::Style.find_style(find_style[:style]).beers
      
      green_beer = "Name".green.bold
      interlude = " | "
      bold_brewery = "Brewery".red.bold
      abv = "ABV".bold
      score = "Score".yellow.bold
      complete_beer = green_beer << interlude << bold_brewery << interlude << abv << interlude << score
      
      puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
      puts "#{find_style[:style]}".bold
      puts " "
      puts "Type a beer name for more info.".yellow.bold
      puts complete_beer
      puts " "
      
      beers.collect! do |beer|
        green_beer1 = "#{beer.name}".green.bold
        interlude1 = " | "
        bold_brewery1 = "#{beer.brewery.name}".red.bold
        abv1 = "#{beer.abv}".bold
        score1 = "#{beer.score}".yellow.bold
        complete_beer1 = green_beer1 << interlude1 << bold_brewery1 << interlude1 << abv1 << interlude1 << score1
        complete_beer1
      end
      beers.uniq!.sort!
      
      puts beers
      puts " "
      puts complete_beer
      puts "Type a beer name for more info.".yellow.bold
      puts " "
      puts "#{find_style[:style]}".bold
      puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
      show_beer(take_input)
    end
  end
  
  def show_brewery_input
    case take_input
    when "1"
      beers = BeerAdvocate::Brewery.find_brewery(@find_brewery[:brewery]).beers
      #binding.pry
      green_beer = "Name".green.bold
      interlude = " | "
      bold_style = "Style".red.bold
      abv = "ABV".bold
      score = "Score".yellow.bold
      complete_beer = green_beer << interlude << bold_style << interlude << abv << interlude << score
      
      puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
      puts "#{find_brewery[:brewery]}".bold
      puts " "
      puts "Type a beer name for more info.".yellow.bold
      puts complete_beer
      puts " "
      
      colored_beers = beers.collect do |beer|
        green_beer1 = "#{beer.name}".green.bold
        interlude1 = " | "
        bold_style1 = "#{beer.style.name}".red.bold
        abv1 = "#{beer.abv}".bold
        score1 = "#{beer.score}".yellow.bold
        complete_beer1 = green_beer1 << interlude1 << bold_style1 << interlude1 << abv1 << interlude1 << score1
        complete_beer1
      end
      
      puts colored_beers
      puts " "
      puts complete_beer
      puts "Type a beer name for more info.".yellow.bold
      puts " "
      puts "#{find_brewery[:brewery]}".bold
      puts " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ".light_blue
      show_beer(take_input)
    else
      puts ""
      puts "Type 1:".bold
      show_brewery_input
    end
  end
  
  def show_brewery(brewery)
    @find_brewery = @beer_list.find do |listed_beer|
      listed_beer[:brewery].downcase == brewery.downcase
    end
    
    if find_brewery == nil
      puts ""
      puts "Invalid. Please type the brewery exactly as it appears in the beer list:".bold
      show_brewery(take_input)
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
    
    show_brewery_input
  end
  
  def beer_table_interaction
    show_beers_table
    show_beer(take_input)
  end
  
  def run
    welcome
    welcome_input
  end
  
  def welcome_input
    case take_input
    when "1"
      beer_table_interaction
    when "2"
      show_styles_list
    when "3"
      puts ""
      puts "Type beer name:".bold
      show_beer(take_input)
    when "4"
      puts ""
      puts "Type brewery name:".bold
      show_brewery(take_input)
    else
      puts ""
      puts "Invalid. Please type 1-4:".bold
      welcome_input
    end
  end
end