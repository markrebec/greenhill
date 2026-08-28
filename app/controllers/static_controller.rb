# frozen_string_literal: true

# Renders the React app shell (app/views/static/index.html.erb via the
# default layout, which pulls in the Vite entrypoint). Root, and eventually
# a catch-all for client-side routing.
class StaticController < ApplicationController
  def index; end
end
