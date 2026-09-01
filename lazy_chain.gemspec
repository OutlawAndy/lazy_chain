require_relative "lib/lazy_chain/version"

Gem::Specification.new do |spec|
  spec.name        = "lazy_chain"
  spec.version     = LazyChain::VERSION
  spec.authors     = [ "Andy Cohen" ]
  spec.email       = [ "outlawandy@gmail.com" ]
  spec.homepage    = "https://github.com/OutlawAndy/lazy_chain"
  spec.summary     = "Defer expensive method calls into Turbo Frames so every page renders immediately."
  spec.description = <<~DESC.strip
    Most slow Rails pages are not slow -- a handful of method calls on them are. LazyChain lets you
    mark those calls in your templates and moves them off the critical path. The page renders right
    away, and each deferred value loads on its own in a Turbo Frame as soon as it is ready. Values
    below the fold are never computed at all unless the user scrolls to them. No background job
    infrastructure, no cache to invalidate by hand, and no JavaScript to write -- just standard
    Turbo Frames and standard Rails caching.
  DESC
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.3.1"
end
