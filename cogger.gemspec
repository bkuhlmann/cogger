# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "cogger"
  spec.version = "0.31.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/cogger"
  spec.summary = "A customizable and feature rich logger."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/cogger/issues",
    "changelog_uri" => "https://alchemists.io/projects/cogger/versions",
    "homepage_uri" => "https://alchemists.io/projects/cogger",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Cogger",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/cogger"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 3.3", "<= 3.4"
  spec.add_dependency "core", "~> 1.10"
  spec.add_dependency "logger", "~> 1.6"
  spec.add_dependency "refinements", "~> 12.10"
  spec.add_dependency "tone", "~> 1.10"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
