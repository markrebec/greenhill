# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::InteractionMutationField do
  describe "defaults, as declared on a real mutation" do
    subject(:field) { Mutations::UpdatePassword.fields["user"] }

    it "defaults interaction_result_from to :result" do
      expect(field.interaction_result_from).to eq(:result)
    end

    it "defaults interaction_partial_result to true" do
      expect(field.interaction_partial_result).to be(true)
    end

    it "defaults to nullable, to stay compatible with partial results" do
      expect(field.type.non_null?).to be(false)
    end
  end

  it "does not apply to InteractionMutation's own built-in errors field" do
    expect(Mutations::UpdatePassword.fields["errors"]).not_to be_a(described_class)
  end
end
