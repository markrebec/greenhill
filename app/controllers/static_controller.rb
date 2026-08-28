# frozen_string_literal: true

class StaticController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Normally Rails' static file middleware serves public/index.html directly,
  # before the router is ever consulted — this action only actually runs as a
  # fallback (public/index.html missing, e.g. a fresh checkout before `bun run
  # build`, or public.file_server disabled). Root always renders the React app
  # either way, rather than silently falling through to something else.
  def index
    index_html = Rails.public_path.join('index.html')

    if index_html.exist?
      render file: index_html, layout: false
    else
      render plain: 'public/index.html not found — run `bun run build` first.', status: :service_unavailable
    end
  end
end
