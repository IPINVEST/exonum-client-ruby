# -*- encoding: utf-8 -*-
require File.expand_path('../lib/exonum/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yuri Gomozov"]
  gem.email         = ["grophen@gmail.com"]
  gem.description   = "Light client for Exonum blockchain framework. https://exonum.com"
  gem.summary       = "Exonum light clent written in Ruby"
  gem.homepage      = "https://github.com/IPINVEST/exonum-client-ruby"
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "exonum-client-ruby"
  gem.require_paths = ["lib"]
  gem.version       = Exonum::VERSION
  
  gem.add_dependency('ed25519', '> 0')
  gem.add_dependency('sparse_array', '> 0')
  gem.add_dependency('activesupport', '> 3')
  gem.add_development_dependency('rspec', '> 3')
end
