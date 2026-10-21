require_relative "lib/kaze/version"

Gem::Specification.new do |spec|
  spec.name = "kaze"
  spec.version = Kaze::VERSION
  spec.authors = [ "Cuong Giang" ]
  spec.email = [ "thaicuong.giang@gmail.com" ]
  spec.homepage = "https://github.com/cuonggt/kaze"
  spec.summary = "Opinionated minimal Rails authentication scaffolding with Hotwire, React, or Vue + Tailwind."
  spec.license = "MIT"
  spec.files = Dir["lib/**/*", "stubs/**/*", "CHANGELOG.md", "LICENSE.md", "README.md"]
  spec.executables = %w[ kaze ]
  spec.required_ruby_version = ">= 3.1.0"
  spec.metadata = { "changelog_uri" => "https://github.com/cuonggt/kaze/blob/master/CHANGELOG.md" }

  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.add_development_dependency "railties"
end
