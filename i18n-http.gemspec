require_relative 'lib/i18n/http/version'

Gem::Specification.new do |spec|
  spec.name          = "i18n-http"
  spec.version       = I18n::Http::VERSION
  spec.authors       = ["anjanavv"]
  spec.email         = ["vvanjanaraj@gmail.com"]

  spec.summary       = %q{Used for fetching translation files via HTTP}
  spec.homepage      = "https://github.com/anjanavv/i18n-http"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'i18n'
  spec.add_runtime_dependency 'httparty'
  spec.add_development_dependency 'webmock'
end
