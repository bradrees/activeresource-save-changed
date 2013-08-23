# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeresource-save-changed/version'

Gem::Specification.new do |gem|
  gem.name          = "activeresource-save-changed"
  gem.version       = ActiveResource::SaveChanged::VERSION
  gem.authors       = ["Bradley Rees"]
  gem.email         = ["github@bradleyrees.com"]
  gem.description   = %q{Added methods for only saving specified fields for ActiveResource objects}
  gem.summary       = %q{Added methods for only saving specified fields for ActiveResource objects}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('activeresource')

  gem.add_development_dependency('rake')
end
