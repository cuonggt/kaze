# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing user facing. Development and CI only.

### Changed

- Updated development dependencies, clearing 62 Dependabot advisories against `Gemfile.lock`. The lockfile is not shipped in the gem, so this affects contributors and CI only ([#16](https://github.com/cuonggt/kaze/pull/16))
- CI reports a single stable `Stub Tests` check alongside the per-stack jobs, so branch protection no longer depends on job names generated from the test matrix ([#18](https://github.com/cuonggt/kaze/pull/18))

### Documentation

- Recorded that Kaze targets Rails 8.1 on Ruby 3.4, and that Rails 8.0 is not supported ([#17](https://github.com/cuonggt/kaze/pull/17))

## [1.2.0] - 2026-10-21

### Fixed

- `kaze install` no longer fails on current Rails. The `bin/bundle` fallback added in 1.1.0 only covered `install_gems` and `remove_gems`; all three stacks still invoked `bin/bundle` directly to add `tailwindcss-rails`. Rails has not generated that binstub since 7.1, so the step failed, `tailwindcss-rails` never reached the Gemfile, and the subsequent `tailwindcss:build` aborted with `UnrecognizedCommandError` ([#11](https://github.com/cuonggt/kaze/issues/11))
- A failed Tailwind or Node step now aborts the install instead of printing `Kaze scaffolding installed successfully.` over it. Exit statuses from these commands were discarded, so a completely failed build still reported success
- `run_command` reads subprocess output as UTF-8 and scrubs invalid bytes. Where no locale is configured — Docker images, CI containers, cron — Ruby tagged output as US-ASCII and any non-ASCII byte aborted the install with `invalid byte sequence in US-ASCII`. Vite triggered this on every Inertia install, via the check mark in its build summary

### Changed

- All three stacks migrated to Tailwind CSS v4 ([#14](https://github.com/cuonggt/kaze/pull/14)). `tailwindcss-rails` moves to `~> 4.0`, `config/tailwind.config.js` is removed, and the stylesheet entry point moves from `app/assets/stylesheets/application.tailwind.css` to `app/assets/tailwind/application.css`, which `tailwindcss-rails` 4.x expects. Configuration now lives in CSS: the Inter font as `@theme`, the forms plugin as `@plugin`, and the former `content` globs as `@source` directives. 76 renamed utilities were updated across the stubs, and Preflight's `cursor: default` on buttons is restored to `cursor: pointer`
- `tailwindcss`, `@tailwindcss/forms`, `autoprefixer` and `postcss` removed from the Inertia stubs. The gem's CLI builds the CSS and Vite only imports the result, so nothing consumed them
- Vite bumped to `^6.4.4` in the Inertia stubs, clearing two high and four moderate advisories ([#12](https://github.com/cuonggt/kaze/pull/12))

Together these take a freshly scaffolded Inertia application from seven npm advisories, five of them high, to zero.

### Internal

- CI runs against Rails 8.1 on Ruby 3.4, reports every matrix job rather than cancelling siblings on the first failure, and passes for the first time ([#13](https://github.com/cuonggt/kaze/pull/13), [#15](https://github.com/cuonggt/kaze/pull/15))

## [1.1.0] - 2025-10-31

### Fixed

- Fall back to the system `bundle` when `bin/bundle` does not exist. Incomplete; see 1.2.0

## [1.0.1] - 2025-02-03

### Fixed

- Remove the `hotwire_livereload_tags` helper when upgrading to hotwire-livereload v2 ([#10](https://github.com/cuonggt/kaze/pull/10))

## [1.0.0] - 2025-02-02

### Changed

- Pin `tailwindcss` to v3 ([#6](https://github.com/cuonggt/kaze/pull/6))
- Unpin the TypeScript version ([#7](https://github.com/cuonggt/kaze/pull/7))

### Fixed

- Type error in the Login component's `setData` call ([#9](https://github.com/cuonggt/kaze/pull/9))

## Earlier releases

Releases before 1.0.0 are not catalogued here. See the [tags](https://github.com/cuonggt/kaze/tags) for their history.

[Unreleased]: https://github.com/cuonggt/kaze/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/cuonggt/kaze/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/cuonggt/kaze/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/cuonggt/kaze/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/cuonggt/kaze/compare/v0.19.0...v1.0.0
