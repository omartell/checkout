# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'checkout/version'

Gem::Specification.new do |spec|
  spec.name          = "checkout"
  spec.version       = Checkout::VERSION
  spec.authors       = ["Oliver Martell"]
  spec.email         = ["oliver.martell@gmail.com"]
  spec.description   = "Checkout Kata"
  spec.summary       = "Checkout Kata"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
end
