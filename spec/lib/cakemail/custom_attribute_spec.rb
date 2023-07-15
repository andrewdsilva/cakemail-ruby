RSpec.describe Cakemail::CustomAttributes do
  describe "Cakemail::CustomAttributes" do
    before(:each) do
      # Get first list
      @list = VCR.use_cassette("attributes.lists") do
        Cakemail::List.list.first
      end
    end

    it "Should raise exception if request custtom attributes without list" do
      expect { Cakemail::CustomAttributes.list }.to raise_error(Cakemail::Base::NoParentError)
    end

    it "Should not raise exception if request custtom attributes with list" do
      VCR.use_cassette("attributes.all.without_error") do
        expect { Cakemail::CustomAttributes.list(parent: @list) }.not_to raise_error
      end
    end

    it "Should create a new custom attribute" do
      attribute = VCR.use_cassette("attribute.create") do
        params = { name: "firstname", type: "text" }

        Cakemail::CustomAttributes.create params, parent: @list
      end

      expect(attribute).to be_an Cakemail::CustomAttributes
    end

    it "Should get list of custom attributes from list object" do
      attributes = VCR.use_cassette("list.attributes") do
        @list.custom_attributes
      end

      expect(attributes.last).to be_an Cakemail::CustomAttributes
      expect(attributes.last.name).to eq("firstname")
    end

    it "Should create contact with custom attributes" do
      attribute = VCR.use_cassette("list.attributes") do
        @list.custom_attributes.first
      end

      params = {
        email: "nathan.lopez042@gmail.com",
        custom_attributes: [
          {
            name: attribute.name,
            value: "Nathan"
          }
        ]
      }

      contact = VCR.use_cassette("attribute.create_contact_with_custom_attribute") do
        @list.create_contact params
      end

      expect(contact).to be_an Cakemail::Contact
      expect(contact.custom_attributes.length).to eq(1)
      expect(contact.custom_attributes.first["name"]).to eq(attribute.name)
      expect(contact.custom_attributes.first["value"]).to eq("Nathan")
    end
  end
end
