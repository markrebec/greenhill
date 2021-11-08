$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "greenhill/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "greenhill"
  spec.version     = Greenhill::Version::VERSION
  spec.authors     = ["Mark Rebec"]
  spec.email       = ["mark@markrebec.com"]
  spec.homepage    = "https://github.com/markrebec/greenhill"
  spec.summary     = "Rails generators and templates for 'greenfield' applications"
  spec.description = "Rails generators and templates for 'greenfield' applications"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "rails", ">= 5"
  # spec.add_dependency "zuul", ">= 0.4.0"
end