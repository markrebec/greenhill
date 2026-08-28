# Session Start

Read the latest session handoff if one exists. Load only the files that handoff references. If no handoff exists, ask: what is the project, what type of work, what is the target deliverable.

Session working docs (plans, handoffs, summaries) are kept in your local Claude working-docs directory, outside the repo — not committed. The exact location is configured per-user (e.g. in your personal `~/.claude/CLAUDE.md`); this file does not assume an in-repo path.

For a project overview and an index of all documentation, see `README.md`.

## Session Rules

1. Do not mix unrelated project contexts in one session.
2. Write state to disk, not conversation. After meaningful work, write a summary to your local session-docs directory. Include: decisions with rationale, file paths, open items.
3. Before compaction or session end, write to disk: every decision with rationale, every open question, every file path, exact next action.
4. When switching work types, write a handoff (`handoff-[date]-[topic].md`) to your local session-docs directory and suggest a new session.
5. Do not silently resolve open questions. Mark them OPEN or ASSUMED.

## Plans, Handoffs & Review

- **Default (review mode):** when working through a plan with multiple phases or steps, complete the instructed scope and pause for review and feedback. Do not commit changes unless the user explicitly asks.
- **Full-auto mode** applies only when the user explicitly opts in for a defined scope — either by saying so ("full auto", "end to end", "autonomously", "don't pause") or by confirming when you offer it. In full-auto mode, work through all phases without pausing: implement, test, lint, commit, push, and open a PR at each phase or deploy boundary. Open each PR and leave it for the user to review and merge — do not merge, delete branches, or run the merge/rebase loop yourself; move on to the next chunk. Absent an explicit opt-in, review mode applies. The opt-in covers the stated scope only; newly expanded scope reverts to review mode.
- When writing a handoff, also update the authoritative plan (if one exists) to reflect current status — mark completed items, add new open questions, update "in progress" markers.
- When a handoff corresponds to a plan phase, add a reference to the handoff file path in the plan's implementation progress section so future sessions can trace the full history.
- Session plans and handoffs are local working documents kept outside the repo for session continuity. They are never committed.
- Promote durable knowledge out of session memory and working docs into the repo: prescriptive rules go to the nearest `CLAUDE.md`; architecture or domain explanations go to `docs/` (cross-cutting), linked from the docs index in `README.md`. Plans and handoffs stay in your local session-docs location; when one contains durable architecture, distill that into `docs/` rather than committing the working file.

## Coding Practices

- Follow DRY principles: extract shared logic into reusable helpers rather than duplicating code.
- Use generators wherever possible for both ruby/rails and typescript/react, rather than copying or writing things from scratch. For example `rails g controller Name`.

## After Code Changes

- Run `bun lint --fix` after modifying any source or test file.
- Run `bun format` after modifying any TypeScript source or test file (`src/`).
- Keep diffs scoped to the change. When a codegen, format, or build step (for example `bun run graphql:types`) reformats or regenerates files unrelated to the current change, revert those files before committing.
- `bun lint --fix` and formatters autocorrect whole files, including pre-existing style on lines the change did not touch. Prefer reverting autocorrect on untouched lines to keep the diff reviewable; use judgment, do not over-engineer.

## Testing

- Run `bun run test` for the full suite (JS via `bun test`, Ruby via `bundle exec rspec`). This is a single flat package, not a workspace — no `--filter` needed.
- Tests must verify real behavior, not tautologies. Never assert that a mock equals itself or that stubbed return values match their own setup. Each assertion should exercise actual logic.
- Define factory helpers (`createMockDb()`, `createMockLogger()`, etc.) at the top of test files rather than rebuilding mock objects inline in each test.

## Dependencies

- Pin exact versions when adding dependencies. Do not use `^`, `~`, `>`, `>=`, or range specifiers in package.json.

## Environment & Config

- Document every env var in `.env.example`.

## Configuration

- ESLint (`eslint.config.mjs`), Prettier (`.prettierrc.json`), and TypeScript (`tsconfig.json`) configs live at the repo root — this is a single app, not a multi-package workspace, so there's no shared `packages/config/` to extend from.
- `src/` is the React app root directly (not one of several apps) — nested folders like `components/`, `hooks/`, etc. live straight under `src/`, not under a per-app subdirectory. Vite's entrypoint lives at `src/entrypoints/application.tsx` (`vite_ruby`'s convention).
- The main app is served through `vite_rails`, not the asset pipeline (`--skip-asset-pipeline` at generation time still applies). There is one dev URL — `localhost:3000` — always; `app/views/layouts/application.html.erb`'s `vite_javascript_tag`/`vite_client_tag` point at the Vite dev server (`bin/vite dev`, port 3036) when it's running, or resolve to the built manifest in `public/vite/` otherwise. Never visit the Vite dev server's own port directly. ActiveAdmin is the one exception to all of this: it requires Sprockets (`sprockets-rails` + `sassc`), scoped to its own assets only (`app/assets/`, `app/assets/config/manifest.js`) — doesn't touch the Vite pipeline.
- A `.tsx` entrypoint needs `vite_javascript_tag 'application.tsx'` (explicit extension) — `vite_typescript_tag` only handles plain `.ts`.
- API requests from the client are same-origin, plain relative paths (`/users/sign_in`, not `/api/users/sign_in`) — no CORS, no dev-server proxy needed, since the page is always served by Rails.

## Adding More Rules

- Only add actionable rules to this file. "Always", "Never", "Only", no subjective language.
- Do not place code-snippets into the rules. Place reusable code snippets in the appropriate directory and reference them directly.
- On git push, suggest new rules to add from any conversations since the last push, and if accepted, add them to the most appropriate CLAUDE.md file.

## Git & Environment

- Always check live git state (`git branch --show-current`, `git status`) when you need the current branch name or working tree state. The session-start snapshot goes stale after the first commit or branch switch.
- Never run `bundle exec rails graphql:schema:dump` directly. Always use `bun run graphql:types` from the monorepo root — it chains the schema export with frontend codegen.

## Multi-PR & Staged Deploys

- For work that must deploy in ordered stages, use ordered branch names: `<user>/<topic>-phase-N`.
- Stack the PRs: each phase's PR targets the previous phase's branch so its review diff is scoped to that phase. State the deploy order and link the stack in each PR body. All phases ultimately merge into the default branch in order, not nested; GitHub auto-retargets a dependent PR to the default branch when the branch below it is merged and deleted (the repo auto-deletes merged branches).
- Backend and frontend deploy together as one app/pipeline (not as separate service releases), but still stage zero-downtime migrations when a change isn't safely atomic: (migration plus backend code that tolerates both the old and new schema) → (backend code that actively depends on the new schema) → (frontend that depends on the new API shape). One release per dependency hop. Never ship a migration in the same release as code that assumes it's already applied; never ship a frontend that depends on backend behavior that hasn't shipped yet.

## Package-Specific Rules

- Always read the nearest `CLAUDE.md` up the directory tree for any file you are working on, and apply it alongside this root file.

## Personal claude rules
- Read any `.claude_rules.md` files which exist and apply those rules as if they were in the nearest `CLAUDE.md`

