Gem::Specification.new do |spec|
  spec.name          = "lita-build-notifications"
  spec.version       = "0.1.2"
  spec.authors       = ["Daniel Eder"]
  spec.email         = ["daniel@deder.at"]
  spec.description   = "Allows to post build status information from HTTP to chat channels."
  spec.summary       = "This plugin provides a HTTP endpoint to post build status information and publishes it to subscribers in the chat."
  spec.homepage      = "https://github.com/lycis/lita-build-notification"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
