# frozen_string_literal: true

require "rails_helper"

RSpec.describe GreenhillSchema do
  describe ".type_for" do
    it "maps a model to the object type named after it" do
      expect(described_class.type_for(build(:user))).to eq(Types::UserType)
    end

    it "raises for an object without a matching type" do
      expect { described_class.type_for(Object.new) }
        .to raise_error(GraphQL::RequiredImplementationMissingError, /No GraphQL type for Object/)
    end
  end

  describe ".object_from_id" do
    it "finds a record by its global ID" do
      user = create(:user)
      expect(described_class.object_from_id(described_class.id_from_object(user, nil, nil), {})).to eq(user)
    end

    it "returns nil for a deleted record" do
      user = create(:user)
      global_id = described_class.id_from_object(user, nil, nil)
      user.destroy!
      expect(described_class.object_from_id(global_id, {})).to be_nil
    end

    it "returns nil for a malformed ID" do
      expect(described_class.object_from_id("nonsense", {})).to be_nil
    end
  end

  describe "connection page sizes" do
    let(:connection_type) do
      item_type = Class.new(Types::BaseObject) do
        graphql_name "PageSizeSpecItem"
        field :id, GraphQL::Types::ID, null: false
      end
      Class.new(Types::BaseObject) do
        graphql_name "PageSizeSpecQuery"
        field :items, item_type.connection_type, null: false
        define_method(:items) { (1..100).map { |id| { id: id } } }
      end
    end

    let(:schema) do
      query_type = connection_type
      Class.new(described_class) { query(query_type) }
    end

    def count(arguments = "")
      schema.execute("{ items#{arguments} { nodes { id } } }").dig("data", "items", "nodes").size
    end

    it "returns a default page when none is asked for" do
      expect(count).to eq(20)
    end

    it "caps the page size" do
      expect(count("(first: 100)")).to eq(50)
    end
  end
end
