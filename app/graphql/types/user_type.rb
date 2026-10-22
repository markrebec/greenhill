# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'A registered user.'

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'When the user was created.'
    field :email, String, null: false, description: "The user's email address."
    field :id, ID, null: false, description: "The user's unique identifier."
  end
end
