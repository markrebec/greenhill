class AuthJsonFailureApp < Devise::FailureApp
  def http_auth_body
    return super unless request_format == :json
    {
      success: false,
      error: i18n_message
    }.to_json
  end
end