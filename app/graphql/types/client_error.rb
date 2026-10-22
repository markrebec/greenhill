# frozen_string_literal: true

module Types
  class ClientError < Types::BaseObject
    description "A client-presentable error, generally returned from mutations."

    field :code, String, null: true, description: "A machine-readable code identifying the type of error."

    field :message, String, null: false, description: "A user-presentable description of the error."
    field :path, [String], null: true, description: "The input path this error applies to, if any."
  end
end
