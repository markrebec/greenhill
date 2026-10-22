# frozen_string_literal: true

class ApplicationInteraction < ActiveInteraction::Base
  include Graphqlable

  def interpret_record(record)
    errors.merge!(record.errors) unless record.valid?
    record
  end
end
