module Responders::AuthJsonResponder
  protected

  def json_resource_errors
    {
      success: false,
      error: resource.errors.full_messages.join('. ')
    }
  end
end