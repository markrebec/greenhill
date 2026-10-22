# frozen_string_literal: true

require "rails_helper"

RSpec.describe Punditable do
  let(:dummy_class) do
    Class.new do
      include Punditable

      attr_accessor :context

      # Pundit::Authorization's helpers are protected, matching how they're
      # meant to be called from within a resolver method on `self` — these
      # thin wrappers let the spec exercise them the same way.
      def call_policy(record)
        policy(record)
      end

      def call_authorize(record, query)
        authorize(record, query)
      end
    end
  end

  let(:instance) { dummy_class.new }
  let(:user) { create(:user) }

  before { instance.context = { current_user: user } }

  it "resolves pundit_user from context[:current_user]" do
    expect(instance.pundit_user).to eq(user)
  end

  it "resolves policy(record) to the matching Policy class" do
    expect(instance.call_policy(user)).to be_a(UserPolicy)
  end

  it "authorizes using the resolved pundit_user" do
    expect(instance.call_authorize(user, :show?)).to eq(user)
  end

  it "raises when the pundit_user is not authorized" do
    instance.context = { current_user: create(:user) }

    expect { instance.call_authorize(user, :show?) }.to raise_error(Pundit::NotAuthorizedError)
  end
end
