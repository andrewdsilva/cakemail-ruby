# frozen_string_literal: true

RSpec.describe Cakemail do
  it "Has a version number" do
    expect(Cakemail::VERSION).not_to be nil
  end

  it "Has api key" do
    expect(Cakemail.config.api_key).not_to be nil
  end
end
