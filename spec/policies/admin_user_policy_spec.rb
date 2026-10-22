# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminUserPolicy do
  subject(:policy) { described_class.new(pundit_user, record) }

  let(:record) { create(:admin_user) }

  context "when the pundit_user is an admin" do
    let(:pundit_user) { create(:admin_user) }

    it { is_expected.to permit_all_actions }
  end

  context "when the pundit_user is a regular user" do
    let(:pundit_user) { create(:user) }

    it { is_expected.to forbid_all_actions }
  end

  context "when signed out" do
    let(:pundit_user) { nil }

    it { is_expected.to forbid_all_actions }
  end
end
