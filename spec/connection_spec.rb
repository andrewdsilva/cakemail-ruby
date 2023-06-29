RSpec.describe Cakemail do
  describe "Cakemail::create_token" do
    it "Should connect with username and password" do
      @login = Cakemail.create_token

      # @login = VCR.use_cassette("create_token") do
      #   Cakemail.create_token
      # end

      expect(@login).to eq "ok"
    end
  end
end
