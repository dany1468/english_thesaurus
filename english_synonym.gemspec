# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'english_thesaurus/version'

Gem::Specification.new do |spec|
  spec.name          = "english_thesaurus"
  spec.version       = EnglishThesaurus::VERSION
  spec.authors       = ["dany1468"]
  spec.email         = ["dany1468@gmail.com"]

  spec.summary       = %q{Scrape thesaurus from Thesaurus.com}
  spec.description   = %q{Scrape thesaurus from Thesaurus.com}
  spec.homepage      = "https://github.com/dany1468/thesaurus"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'activesupport'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
