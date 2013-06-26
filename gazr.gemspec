# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gazr/version'

Gem::Specification.new do |spec|
  spec.name          = "gazr"
  spec.version       = Gazr::VERSION
  spec.authors       = ["James Akers"]
  spec.email         = ["j.f.akers@gmail.com"]
  spec.description   = %q{Flexible, Simple alternative to Guard. Watchr for Ruby 1.9.3 and beyond.}
  spec.summary       = %q{Flexible, Simple alternative to Guard. Watchr for Ruby 1.9.3 and beyond.}
  spec.homepage      = "http://github.com/jamesakers/gazr"
  spec.license       = "MIT"

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/*}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end
