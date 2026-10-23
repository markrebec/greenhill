# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::Associations do
  let(:profile_type) do
    Class.new(Types::BaseObject) do
      graphql_name "AssociationsSpecProfile"
      field :id, GraphQL::Types::ID, null: false
    end
  end

  let(:user_type) do
    referenced_profile_type = profile_type

    Class.new(Types::BaseObject) do
      graphql_name "AssociationsSpecUser"
      association :profile, referenced_profile_type
      association :articles, [referenced_profile_type], to: :posts, scope: -> { :scoped_marker }
    end
  end

  def instance_for(type)
    type.send(:new, :the_object, {})
  end

  describe ".association" do
    it "declares a field using the given type" do
      expect(user_type.fields["profile"].type.unwrap).to eq(profile_type)
    end

    it "defaults to: to the field name" do
      instance = instance_for(user_type)
      allow(instance).to receive(:dataload_association)

      instance.profile

      expect(instance).to have_received(:dataload_association).with(:profile, scope: nil)
    end

    it "uses the to: override as the actual association name, and resolves a callable scope" do
      instance = instance_for(user_type)
      allow(instance).to receive(:dataload_association)

      instance.articles

      expect(instance).to have_received(:dataload_association).with(:posts, scope: :scoped_marker)
    end
  end
end
