RSpec.describe Cakemail::List do
  describe "Cakemail::List" do
    before(:each) do
      # Get all lists
      @lists = VCR.use_cassette("lists") do
        Cakemail::List.list
      end
    end

    it "Should find all lists with correct attributes" do
      expect(@lists.first.id).to be_an Integer
      expect(@lists.first.name).to be_an String
      expect(@lists.first.status).to be_an String
      expect(@lists.first.language).to be_an String
      expect(@lists.first.created_on).to be_an Integer
    end

    it "Should find a list by id with correct attributes" do
      # Get one list
      list = VCR.use_cassette("list") do
        Cakemail::List.find(@lists.first.id)
      end

      expect(list.id).to be_an Integer
      expect(list.name).to be_an String
      expect(list.status).to be_an String
      expect(list.language).to be_an String
      expect(list.created_on).to be_an Integer
    end

    it "Should count the total number of lists" do
      count = VCR.use_cassette("lists.count") do
        Cakemail::List.count
      end

      expect(count).to eq(@lists.length)
    end

    it "Should find all objects in batch" do
      count = VCR.use_cassette("lists.count") do
        Cakemail::List.count
      end

      all_objects = 0

      VCR.use_cassette("lists.find_in_batches") do
        Cakemail::List.find_in_batches do
          all_objects += 1
        end
      end

      expect(count).to eq(all_objects)
    end

    it "Should create a new list" do
      # Get sender
      sender = VCR.use_cassette("list.sender") do
        Cakemail::Sender.list.first
      end

      list = VCR.use_cassette("list.create") do
        params = { name: "My list", language: "fr_CA", default_sender: { id: sender.id } }

        Cakemail::List.create params
      end

      expect(list).to be_an Cakemail::List
    end

    it "Should update a list" do
      # Get the last list
      list = VCR.use_cassette("lists.for_update") do
        Cakemail::List.list
      end

      # Update the last list
      list_updated = VCR.use_cassette("list.update") do
        list.last.update(name: "New name")
      end

      expect(list_updated).to be_an Cakemail::List
      expect(list_updated.name).to eq("New name")
    end

    it "Should archive a list" do
      # Get the last list
      list = VCR.use_cassette("lists.for_archive") do
        Cakemail::List.list
      end

      # Delete the last list
      list_archived = VCR.use_cassette("list.archive") do
        list.last.archive
      end

      expect(list_archived).to be_an Cakemail::List
      expect(list_archived.id).to eq(list.last.id)
    end

    it "Should unarchive a list" do
      # Get the last list
      list = VCR.use_cassette("lists.for_unarchive") do
        Cakemail::List.list filters: { "status": "archived" }
      end

      # Delete the last list
      list_unarchived = VCR.use_cassette("list.unarchive") do
        list.last.unarchive
      end

      expect(list_unarchived).to be_an Cakemail::List
      expect(list_unarchived.id).to eq(list.last.id)
    end

    it "Should delete a list" do
      # Get the last list
      list = VCR.use_cassette("lists.for_deletation") do
        Cakemail::List.list
      end

      # Delete the last list
      deletation = VCR.use_cassette("list.delete") do
        list.last.delete
      end

      expect(deletation).to eq(true)
    end
  end
end
