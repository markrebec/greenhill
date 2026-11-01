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
end
