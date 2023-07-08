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

    it "Should create a new contact from the list" do
      contact = VCR.use_cassette("contact.create_from_list") do
        params = { email: "nathan.lopez042@gmail.com" }

        @list.create_contact params
      end

      expect(contact).to be_an Cakemail::Contact
    end

    it "Should update contact" do
      # Get the last contact
      contact = VCR.use_cassette("contacts.for_update") do
        @list.contacts.last
      end

      new_mail = "#{Time.now.to_i}@gmail.com"

      # Update the last contact
      contact_updated = VCR.use_cassette("contact.update") do
        contact.update(email: new_mail)
      end

      expect(contact_updated).to be_an Cakemail::Contact
    end

    it "Should unsubscribe a contact" do
      # Get the last contact
      contact = VCR.use_cassette("contacts.for_unsubscribe") do
        @list.contacts.last
      end

      # Unsubscribe the last contact
      contact_unsubscribed = VCR.use_cassette("contact.unsubscribe") do
        contact.unsubscribe
      end

      expect(contact_unsubscribed).to be_an Cakemail::Contact
      expect(contact_unsubscribed.status).to eq("unsubscribed")
    end

    it "Should delete all contacts" do
      # Get all the contacts
      contacts = VCR.use_cassette("contacts.for_deletation") do
        @list.contacts
      end

      # Delete all the contacts
      VCR.use_cassette("contacts.delete") do
        contacts.each do |contact|
          deletation = contact.delete

          expect(deletation).to eq(true)
        end
      end
    end
  end
end
