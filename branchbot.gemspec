# frozen_string_literal: true

require_relative "lib/branchbot/version"

Gem::Specification.new do |spec|
  spec.name          = "branchbot"
  spec.version       = Branchbot::VERSION
  spec.authors       = ["Jim Ryan"]
  spec.email         = ["jim@room118solutions.com"]

  spec.summary       = "Saves and restores the state of your local database as you work on different git branches."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/room118solutions/branchbot"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/room118solutions/git-rails-database-branch-hook"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = ['branchbot']
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_runtime_dependency "commander", '~> 4.6.0'
  
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
