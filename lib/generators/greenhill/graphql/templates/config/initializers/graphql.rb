# NOTE this option currently requires using the 'master' branch of graphiql-rails from github...
#      would be a nice addition once it's released
# GraphiQL::Rails.config.header_editor_enabled = true

GraphiQL::Rails.config.headers['Authorization'] = -> (context) {
  "Bearer #{Warden::JWTAuth::UserEncoder.new.call(context.current_admin, :user, Warden::JWTAuth::EnvHelper.aud_header({}))[0]}"
}