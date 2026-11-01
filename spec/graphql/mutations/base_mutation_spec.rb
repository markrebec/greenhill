# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::BaseMutation do
  let(:mutation) do
    Class.new(described_class) do
      graphql_name "BaseMutationSpecWhoAmI"
      field :email, String, null: true

      def resolve
        { email: signed_in_user!.email }
      end
    end
  end

  let(:schema) do
    mutation_class = mutation
    mutation_type = Class.new(Types::BaseObject) do
      graphql_name "BaseMutationSpecMutation"
      field :who_am_i, mutation: mutation_class
    end
    Class.new(GreenhillSchema) { mutation(mutation_type) }
  end

  def run(current_user)
    schema.execute("mutation { whoAmI(input: {}) { email } }", context: { current_user: current_user })
  end

  describe "#signed_in_user!" do
    it "returns the signed-in user" do
      user = create(:user)
      expect(run(user).dig("data", "whoAmI", "email")).to eq(user.email)
    end

    it "refuses anonymous callers" do
      expect(run(nil)["errors"].first["message"]).to eq("You are not authorized to perform this action.")
    end

    it "refuses admin users, who aren't application users" do
      expect(run(create(:admin_user))["errors"].first["message"])
        .to eq("You are not authorized to perform this action.")
    end
  end
end
