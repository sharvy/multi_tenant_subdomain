# frozen_string_literal: true

require_relative "lib/multi_tenant_subdomain/version"

Gem::Specification.new do |spec|
  spec.name = "multi_tenant_subdomain"
  spec.version = MultiTenantSubdomain::VERSION
  spec.authors = ["Sharvy Ahmed"]
  spec.email = ["sharvy2008@gmail.com"]

  spec.summary = "Multi-tenancy support with subdomain-based tenant isolation using a single database."
  spec.description = "This gem provides subdomain-based multi-tenancy support for Rails applications, using a single database while ensuring tenant isolation."
  spec.homepage = "https://github.com/sharvy/multi_tenant_subdomain"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sharvy/multi_tenant_subdomain"
  spec.metadata["changelog_uri"] = "https://github.com/sharvy/multi_tenant_subdomain/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
