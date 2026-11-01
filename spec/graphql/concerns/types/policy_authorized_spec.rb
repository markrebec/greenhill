# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::PolicyAuthorized do
  let(:user) { create(:user) }

  it "authorizes an object its policy lets the viewer see" do
    expect(Types::UserType.authorized?(user, { current_user: user })).to be true
  end

  it "denies an object its policy hides from the viewer" do
    expect(Types::UserType.authorized?(user, { current_user: create(:user) })).to be false
  end

  it "denies anonymous viewers when the policy requires a user" do
    expect(Types::UserType.authorized?(user, { current_user: nil })).to be false
  end
end
