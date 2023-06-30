RSpec.describe Cakemail::Token do
  describe "Cakemail::Token.create" do
    it "Should connect with username and password" do
      token = VCR.use_cassette("create_token") do
        Cakemail::Token.create
      end

      expect(token).to be_a(Cakemail::Token)
      expect(token.access_token).not_to eq(nil)

      pp "Access token created is #{token.access_token}"
    end

    it "Should not connect with wrong username and password" do
      token = VCR.use_cassette("create_wrong_token") do
        Cakemail::Token.create("wrong_user", "wrong_p@ssword")
      end

      expect(token).not_to be_a(Cakemail::Token)
      expect(token["detail"]).not_to eq(nil)
    end
  end
end
