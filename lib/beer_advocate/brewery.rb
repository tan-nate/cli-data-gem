class BeerAdvocate::Brewery
  attr_accessor :name, :beers, :brewery_url
  
  @@all = []
  
  def initialize(name)
    @@all << self
    @name = name
    @beers = []
  end
  
  def add_beer(beer)
    beers << beer
  end
  
  def self.all
    @@all
  end
  
  def self.find_brewery(brewery)
    self.all.find {|x| x.name == brewery}
  end
  
  def self.find_or_create(brewery)
    if self.find_brewery(brewery) == nil
      self.new(brewery)
    else
      self.find_brewery(brewery)
    end
  end
end