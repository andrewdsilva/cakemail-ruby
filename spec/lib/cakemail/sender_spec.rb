RSpec.describe Cakemail::Sender do
  describe "Cakemail::Sender" do
    before(:each) do
      # Get all senders
      @senders = VCR.use_cassette("senders") do
        Cakemail::Sender.list
      end
    end

    it "Should find all senders with correct type and attributes" do
      expect(@senders.first).to be_an Cakemail::Sender

      expect(@senders.first.name).to be_an String
      expect(@senders.first.email).to be_an String
    end
  end
end
