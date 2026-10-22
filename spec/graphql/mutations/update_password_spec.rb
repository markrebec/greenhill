# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdatePassword do
  let(:user) { create(:user, password: 'password123') }

  let(:query) do
    <<~GQL
      mutation UpdatePassword($currentPassword: String!, $password: String!, $passwordConfirmation: String!) {
        updatePassword(input: {
          currentPassword: $currentPassword
          password: $password
          passwordConfirmation: $passwordConfirmation
        }) {
          user { id }
          errors
        }
      }
    GQL
  end

  def execute(current_user:, current_password: 'password123', password: 'newpassword123',
              password_confirmation: 'newpassword123')
    MeeteorSchema.execute(
      query,
      variables: {
        currentPassword: current_password,
        password: password,
        passwordConfirmation: password_confirmation
      },
      context: { current_user: current_user }
    )
  end

  context 'when signed in with the correct current password' do
    let(:payload) { execute(current_user: user).dig('data', 'updatePassword') }

    it 'returns no errors' do
      expect(payload['errors']).to eq([])
    end

    it 'returns the updated user' do
      expect(payload['user']['id']).to eq(user.id.to_s)
    end

    it 'updates the password' do
      payload
      expect(user.reload.valid_password?('newpassword123')).to be true
    end
  end

  context 'when the current password is wrong' do
    let(:payload) { execute(current_user: user, current_password: 'wrongpassword').dig('data', 'updatePassword') }

    it 'returns a null user' do
      expect(payload['user']).to be_nil
    end

    it 'returns errors' do
      expect(payload['errors']).not_to be_empty
    end

    it 'does not change the password' do
      payload
      expect(user.reload.valid_password?('password123')).to be true
    end
  end

  context 'when signed out' do
    let(:payload) { execute(current_user: nil).dig('data', 'updatePassword') }

    it 'returns a null user' do
      expect(payload['user']).to be_nil
    end

    it 'returns errors' do
      expect(payload['errors']).not_to be_empty
    end
  end

  context 'when the user policy denies update?' do
    let(:result) { execute(current_user: user) }

    before do
      allow(UserPolicy).to receive(:new).and_return(instance_double(UserPolicy, update?: false))
    end

    it 'returns a null payload' do
      expect(result.dig('data', 'updatePassword')).to be_nil
    end

    it 'returns a top-level GraphQL error' do
      expect(result['errors']).to contain_exactly(
        hash_including('message' => 'You are not authorized to perform this action.')
      )
    end

    it 'does not change the password' do
      result
      expect(user.reload.valid_password?('password123')).to be true
    end
  end
end
