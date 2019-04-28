class BeerAdvocate::Brewery
  attr_accessor :name, :beers, :brewery_url
  
  def initialize(name)
    @name = name
    @beers = []
  end
  
  def add_beer(beer)
    beers << beer
  end
end