RSpec.describe Cakemail::Contact do
  describe "Cakemail::Contact" do
    before(:each) do
      # Get first list
      @list = VCR.use_cassette("contacts.lists") do
        Cakemail::List.list.first
      end
    end

    it "Should raise exception if request contacts without list" do
      expect { Cakemail::Contact.list }.to raise_error(Cakemail::Base::NoParentError)
    end

    it "Should not raise exception if request contacts with list" do
      VCR.use_cassette("contacts.all.without_error") do
        expect { Cakemail::Contact.list(parent: @list) }.not_to raise_error
      end
    end

    it "Should create a new contact" do
      contact = VCR.use_cassette("contact.create") do
        params = { email: "nathan.lopez042@gmail.com" }

        Cakemail::Contact.create params, parent: @list
      end

      expect(contact).to be_an Cakemail::Contact
    end

    it "Should get list of contacts from list object" do
      contacts = VCR.use_cassette("list.contacts") do
        @list.contacts
      end

      expect(contacts.last).to be_an Cakemail::Contact
      expect(contacts.last.email).to eq("nathan.lopez042@gmail.com")
    end
  end
end
