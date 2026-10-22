# frozen_string_literal: true

module Punditable
  extend ActiveSupport::Concern
  include Pundit::Authorization

  def pundit_user
    context[:current_user]
  end
end
