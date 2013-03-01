$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "multiparameter_attributes_handler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "multiparameter_attributes_handler"
  s.version     = MultiparameterAttributesHandler::VERSION
  s.authors     = ["Rob Nichols"]
  s.email       = ["rob@undervale.co.uk"]
  s.homepage    = "https://github.com/reggieb/multiparameter_attributes_handler"
  s.summary     = "Allows objects with attributes, to handle multiparameter params"
  s.description = "Rails forms helpers for date and time fields generate multiparameter params. multiparameter_attributes_handler allows objects to assign these to thier attributes,"

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end