$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "zuul/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "zuul"
  spec.version     = Zuul::Version::VERSION
  spec.authors     = ["Mark Rebec"]
  spec.email       = ["mark@markrebec.com"]
  spec.homepage    = "https://github.com/markrebec/zuul"
  spec.summary     = "Pundit-based authorization for GraphQL"
  spec.description = "Pundit-based user authorization for GraphQL Ruby"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "rails", ">= 5"
  spec.add_dependency "pundit", ">= 2"
  spec.add_dependency "graphql-ruby", ">= 1.12"
end