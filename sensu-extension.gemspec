# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "sensu-extension"
  spec.version       = "1.5.0"
  spec.authors       = ["Sean Porter"]
  spec.email         = ["portertech@gmail.com"]
  spec.summary       = "The Sensu extension library"
  spec.description   = "The Sensu extension library"
  spec.homepage      = "https://github.com/sensu/sensu-extension"
  spec.license       = "MIT"

  spec.files         = Dir.glob("lib/**/*") + %w[sensu-extension.gemspec README.md LICENSE.txt]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "eventmachine"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "10.5.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "codeclimate-test-reporter" unless RUBY_VERSION < "1.9"
end
