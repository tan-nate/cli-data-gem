class BeerAdvocate::Style
  attr_accessor :name, :beers, :style_url
  
  def initialize(name)
    @name = name
    @beers = []
  end
  
  def add_beer(beer)
    beers << beer
  end
end