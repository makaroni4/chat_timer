# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chat_timer/version'

Gem::Specification.new do |spec|
  spec.name          = "chat_timer"
  spec.version       = ChatTimer::VERSION
  spec.authors       = ["Anatoli Makarevich"]
  spec.email         = ["makaroni4@gmail.com"]
  spec.description   = %q{Write a gem description}
  spec.summary       = %q{Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files = %w(Rakefile chat_timer.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("bin/**/*")
  spec.files += Dir.glob("spec/**/*")
  spec.executables   = ["chat_timer"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "active_support"
end
