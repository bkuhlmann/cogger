# frozen_string_literal: true

require "pathname"

RSpec.shared_context "with temporary directory" do
  let(:temp_dir) { Bundler.root.join "tmp/rspec" }

  around do |example|
    temp_dir.mkpath
    example.run
    temp_dir.rmtree
  end
end
