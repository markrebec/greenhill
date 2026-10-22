# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdatePassword do
  let(:user) { create(:user, password: 'password123') }

  let(:query) do
    <<~GQL
      mutation UpdatePassword($currentPassword: String!, $password: String!, $passwordConfirmation: String!, $clientMutationId: String) {
        updatePassword(input: {
          currentPassword: $currentPassword
          password: $password
          passwordConfirmation: $passwordConfirmation
          clientMutationId: $clientMutationId
        }) {
          user { id }
          errors { message code path }
          clientMutationId
        }
      }
    GQL
  end

  def execute(current_user:, current_password: 'password123', password: 'newpassword123',
              password_confirmation: 'newpassword123', client_mutation_id: nil)
    MeeteorSchema.execute(
      query,
      variables: {
        currentPassword: current_password,
        password: password,
        passwordConfirmation: password_confirmation,
        clientMutationId: client_mutation_id
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

    it 'returns an error naming current_password' do
      expect(payload['errors']).to contain_exactly(
        hash_including('path' => %w[Mutation updatePassword currentPassword])
      )
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
    let(:payload) { execute(current_user: user).dig('data', 'updatePassword') }

    before do
      allow(UserPolicy).to receive(:new).and_return(instance_double(UserPolicy, update?: false))
    end

    it 'returns a null user' do
      expect(payload['user']).to be_nil
    end

    it 'folds the denial into the errors field, not a top-level GraphQL error' do
      expect(payload['errors']).to contain_exactly(
        hash_including('message' => 'You are not authorized to perform this action.', 'code' => 'notAuthorized')
      )
    end

    it 'does not change the password' do
      payload
      expect(user.reload.valid_password?('password123')).to be true
    end
  end

  context 'with a clientMutationId' do
    it 'echoes it back on success' do
      payload = execute(current_user: user, client_mutation_id: 'abc123').dig('data', 'updatePassword')
      expect(payload['clientMutationId']).to eq('abc123')
    end

    it 'echoes it back when the policy denies update?' do
      allow(UserPolicy).to receive(:new).and_return(instance_double(UserPolicy, update?: false))
      payload = execute(current_user: user, client_mutation_id: 'abc123').dig('data', 'updatePassword')
      expect(payload['clientMutationId']).to eq('abc123')
    end
  end

  context 'when the user policy raises something other than Pundit::NotAuthorizedError' do
    before do
      allow(UserPolicy).to receive(:new).and_return(
        instance_double(UserPolicy).tap { |policy| allow(policy).to receive(:update?).and_raise(RuntimeError, 'boom') }
      )
    end

    it 'does not catch it -- only Pundit::NotAuthorizedError is handled' do
      expect { execute(current_user: user) }.to raise_error(RuntimeError, 'boom')
    end
  end
end
