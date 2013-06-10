# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'faqmarkdown/version'

Gem::Specification.new do |s|
  s.name        = 'faqmarkdown'
  s.version     = Faqmarkdown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Rodrigo Martins']
  s.email       = ['rodrigo@rrmartins.com']
  s.licenses    = ['MIT']

  s.homepage    = ''
  s.summary     = %q{A simple Rails FAQ engine powered by markdown.}
  s.description = s.summary

  s.rubyforge_project = 'faqmarkdown'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib', 'public']

  s.add_dependency 'rails', '~> 3.0'
  s.add_dependency 'haml', '~> 3.1'
  s.add_dependency 'gravtastic'
  s.add_dependency 'nokogiri'
  s.add_dependency 'rdiscount'
  s.add_dependency 'kaminari'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rspec-rails', '~> 2.8'
  s.add_development_dependency 'capybara', '~> 1.0.0.beta'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'delorean', '>= 0.2'
  s.add_development_dependency 'combustion', '~> 0.3.1'
end
