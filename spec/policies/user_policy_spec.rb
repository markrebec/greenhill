# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  subject(:policy) { described_class.new(pundit_user, record) }

  let(:record) { create(:user) }

  context 'when the pundit_user is an admin' do
    let(:pundit_user) { create(:admin_user) }

    it { is_expected.to permit_all_actions }
  end

  context "when the pundit_user is the record's own user" do
    let(:pundit_user) { record }

    it { is_expected.to permit_only_actions(:show, :update, :edit) }
  end

  context 'when the pundit_user is a different user' do
    let(:pundit_user) { create(:user) }

    it { is_expected.to forbid_all_actions }
  end

  context 'when signed out' do
    let(:pundit_user) { nil }

    it { is_expected.to forbid_all_actions }
  end
end
