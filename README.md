# meeteor

A Rails + React/TypeScript starter application.

## Architecture

- **Backend**: Rails 8.1 (Ruby 3.4.9), PostgreSQL.
- **Frontend**: a single React/TypeScript app under `src/`, built with Vite
  (via `vite_rails`) and served directly by Rails — there's one dev URL,
  `http://localhost:3000`, always. There is no separate API host and no
  CORS: the frontend and backend are the same origin.
- **API**: GraphQL (`graphql-ruby`), mounted at `/graphql`. An in-browser
  GraphQL IDE (GraphiQL) is available at `/admin/graphiql`, gated behind an
  `AdminUser` session. A few plain JSON endpoints also exist for
  session-based auth (sign in/out, registration, password reset — see
  `config/routes.rb`), since those map directly onto Devise's own
  controllers.
- **Authentication**: Devise. A self-service `User` model (registration,
  email confirmation, account lockout) and a separately-scoped `AdminUser`
  for admin-only access — both can be signed in simultaneously in the same
  browser.
- **Admin dashboard**: ActiveAdmin, mounted at `/admin`.
- **Service objects**: business logic lives in `ActiveInteraction` classes
  under `app/interactions/`, not in controllers or models directly.
- **UI components**: Tailwind CSS v4 + Radix primitives, following shadcn's
  conventions (`src/components/ui/`).
- **Background jobs / cache**: Rails 8's built-in Solid Queue / Solid Cache /
  Solid Cable — all database-backed, no separate services required for
  local development.

## Requirements

- Ruby 3.4.9 (see `.ruby-version`)
- PostgreSQL (18 via Docker Compose for local dev — see `docker-compose.yml`)
- [Bun](https://bun.sh) — used to run all JS/TS tooling and most of the
  scripts below (`package.json`)
- Docker, for local Postgres and for building the production image

## Setup

```sh
bundle install
bun install
cp .env.example .env   # adjust if needed
docker compose up -d
bin/rails db:prepare
```

## Configuration

Environment variables are loaded from `.env` (via `dotenv-rails`; `.env` is
gitignored). `.env.example` documents every variable currently in use and
its default — keep it up to date when adding a new one.

## Running the app

```sh
bun run dev
```

This runs the Rails server (`bin/rails s`) and the Vite dev server
(`bin/vite dev`) together via `concurrently`. The app is always served at
`http://localhost:3000` — Rails renders the page and injects the
`vite_javascript_tag`/`vite_client_tag` helpers, which point at the Vite dev
server for live JS/HMR when it's running, or fall back to the last build in
`public/vite/` otherwise. **Never visit the Vite dev server's own port
directly** — it isn't a complete app on its own.

To run the two halves separately (e.g. in two terminals):

```sh
bun run dev:server   # bin/rails s
bun run dev:client   # bin/vite dev
```

### Admin

- ActiveAdmin: `/admin` — sign in with an `AdminUser` (seed one via
  `bin/rails console`, e.g. `AdminUser.create!(email: ..., password: ...)`;
  none are seeded by default).
- GraphiQL: `/admin/graphiql` — same `AdminUser` session gate. Note that
  fields resolving against the current *application* user (e.g. `me`) also
  need a signed-in `User` session in the same browser, since the two are
  independent.

## GraphQL schema

The schema is dumped to `schema.graphql` at the repo root, and frontend
types/hooks are generated from it into `src/graphql/generated/` — both are
committed. After changing anything under `app/graphql/`, regenerate both:

```sh
bun run graphql:types
```

Don't run `bundle exec rake graphql:schema:idl` directly — `graphql:types`
chains the schema dump with the frontend codegen (config in `codegen.ts`).

## Testing

```sh
bun run test
```

Runs the full suite: `bun test` (frontend) + `bundle exec rspec` (backend).
This is a single flat package, not a workspace, so there's no
`--filter`/scoping needed. RSpec runs report line coverage via SimpleCov;
see `coverage/index.html` (gitignored) after a run.

Other useful scripts:

```sh
bun run lint        # eslint (src/) + rubocop — check only
bun run lint:fix     # same, but autofix
bun run typecheck    # tsc --noEmit
bun run format       # prettier (src/ only)
```

## Deployment

The app is containerized via the included `Dockerfile` (a multi-stage build
that compiles the Vite/React assets and the Sprockets assets ActiveAdmin and
GraphiQL need, alongside the Rails app itself). `kamal` and
`config/deploy.yml` are present for Docker-based deploys, but `deploy.yml`
still has placeholder values (server IPs, registry) — fill those in before
using `bin/kamal deploy` for real.
