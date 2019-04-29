lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "beer_advocate/version"

Gem::Specification.new do |spec|
  spec.name          = "beer-advocate-cli"
  spec.version       = BeerAdvocate::VERSION
  spec.authors       = ["Nate Tan"]
  spec.email         = "nktan93@gmail.com"

  spec.summary       = "A CLI for the Beer Advocate website (beeradvocate.com)."
  spec.homepage      = "https://github.com/tan-nate/beer-advocate-cli-gem.git"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["beer-advocate"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  
  spec.add_dependency "colorize", "~> 0.8.1"
  spec.add_dependency "nokogiri", "~> 1.6.8"
end
