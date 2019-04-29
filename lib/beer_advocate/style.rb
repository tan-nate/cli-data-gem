class BeerAdvocate::Style
  attr_accessor :name, :beers, :style_url
  
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
  
  def self.find_style(style)
    self.all.find {|x| x.name == style}
  end
  
  def self.find_or_create(style)
    if self.find_style(style) == nil
      self.new(style)
    else
      self.find_style(style)
    end
  end
end