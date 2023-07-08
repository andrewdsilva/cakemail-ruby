# frozen_string_literal: true

require_relative "lib/cakemail/version"

Gem::Specification.new do |spec|
  spec.name = "cakemail-next-gen"
  spec.version = Cakemail::VERSION
  spec.authors = ["Nathan Lopez"]
  spec.email = ["nathan.lopez042@gmail.com"]

  spec.summary = "This library allows you to quickly and easily use the Cakemail Next-gen API via Ruby."
  spec.description = "This library allows you to quickly and easily use the Cakemail Next-gen API via Ruby."
  spec.homepage = "https://github.com/andrewdsilva/cakemail-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andrewdsilva/cakemail-ruby"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
