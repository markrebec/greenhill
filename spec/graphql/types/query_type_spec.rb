# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::QueryType do
  let(:query) { "query { me { id } } " }

  def execute(current_user:)
    GreenhillSchema.execute(query, context: { current_user: current_user })
  end

  context "when signed in" do
    let(:user) { create(:user) }

    it "returns the current user" do
      result = execute(current_user: user)

      expect(result.dig("data", "me", "id")).to eq(user.id.to_s)
    end
  end

  context "when signed out" do
    let(:result) { execute(current_user: nil) }

    it "returns a null user" do
      expect(result["data"]).to eq("me" => nil)
    end

    it "returns no errors" do
      expect(result["errors"]).to be_nil
    end
  end

  context "when the user policy denies show?" do
    let(:user) { create(:user) }
    let(:result) { execute(current_user: user) }

    before do
      allow(UserPolicy).to receive(:new).and_return(instance_double(UserPolicy, show?: false))
    end

    it "returns a null user" do
      expect(result.dig("data", "me")).to be_nil
    end

    it "returns a top-level GraphQL error" do
      expect(result["errors"]).to contain_exactly(
        hash_including("message" => "You are not authorized to perform this action.")
      )
    end
  end
end
