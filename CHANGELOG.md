# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The frontend is rebuilt on [shadcn/ui](https://ui.shadcn.com), following Laravel's [react](https://github.com/laravel/react-starter-kit) and [vue](https://github.com/laravel/vue-starter-kit) starter kits ([#27](https://github.com/cuonggt/kaze/pull/27), [#28](https://github.com/cuonggt/kaze/pull/28), [#29](https://github.com/cuonggt/kaze/pull/29), [#30](https://github.com/cuonggt/kaze/pull/30), [#31](https://github.com/cuonggt/kaze/pull/31), [#32](https://github.com/cuonggt/kaze/pull/32), [#33](https://github.com/cuonggt/kaze/pull/33), [#34](https://github.com/cuonggt/kaze/pull/34)). shadcn copies source into the project rather than shipping a package, which is how Kaze already works, so the primitives are vendored into `Components/ui` and are yours to edit.

  A design token layer comes with it. Colour is now `bg-background`, `text-muted-foreground`, `border-sidebar-border` and so on, resolving through oklch variables defined once per stylesheet, instead of `bg-white dark:bg-gray-800` repeated per element. A `components.json` records the aliases so `npx shadcn@latest add <component>` lands in the right place — note that Kaze uses a capitalised `@/Components`, which that file already reflects.

  Thirteen primitives for each Inertia stack: button, input, label, checkbox, dialog, dropdown-menu, separator, skeleton, sheet, tooltip, avatar, breadcrumb and sidebar, plus a `cn` helper in `lib/utils`. React builds on Radix, Vue on reka-ui.

- A collapsible sidebar replaces the top navigation bar in all three stacks. It collapses to icons, becomes a drawer below `md`, and remembers its state in a `sidebar_state` cookie that the server reads back, so the first paint matches the last choice rather than flashing open.

  There is no shadcn for Hotwire, so its sidebar is hand-rolled in Alpine and ERB against the same tokens, with the lucide icons inlined through a new `IconComponent` since Hotwire has no npm.

- A settings area at `/settings/profile`, `/settings/password` and `/settings/appearance`, replacing the single profile page ([#35](https://github.com/cuonggt/kaze/pull/35), [#36](https://github.com/cuonggt/kaze/pull/36)). `/settings` redirects to the profile page. Each has its own breadcrumb and page title, and the delete-account form stays on the profile page.

### Changed

- **The profile page has moved and its routes with it.** `/profile` is now `/settings/profile`, and password updates post to `/settings/password` rather than to the profile page. The route helper names are unchanged — `profile_edit_path` still exists, it just points somewhere new — so an application that uses the helpers rather than hard-coded paths needs no edit. `password_edit_path` and `appearance_edit_path` are new. `ProfileController` and `PasswordController` become `Settings::ProfileController`, `Settings::PasswordController` and `Settings::AppearanceController`.

- The `dark` variant is redefined, in all three stylesheets:

  ```css
  /* was */ @custom-variant dark (&:where(.dark, .dark *));
  /* now */ @custom-variant dark (&:is(.dark *));
  ```

  `:where()` contributes no specificity, so a `dark:` utility tied with its light counterpart and won or lost on the order Tailwind happened to emit them in — `dark:text-black` lost to `text-white` on the same element. `:is()` gives the variant the higher specificity, which is what Laravel's kits use. If you have written a `dark:` override that was silently losing, it will now apply; if you wrote one that depended on losing, it will not.

- The Vue stack pins `typescript` to `^5.9.3`, down from `^7.0.2` ([#30](https://github.com/cuonggt/kaze/pull/30)). `@vue/compiler-sfc` needs filesystem access to resolve prop types that cross a package boundary, which the vendored primitives do, and the resolver it uses is not compatible with TypeScript 7. The React stack stays on 7.

### Removed

- The hand-rolled components the shadcn primitives replace: `PrimaryButton`, `SecondaryButton`, `DangerButton`, `TextInput`, `InputLabel`, `Checkbox`, `Modal`, `Dropdown`, `NavLink` and `ResponsiveNavLink` from both Inertia stacks, `DropdownLink` from the Vue stack, and `NavLinkComponent` and `ResponsiveNavLinkComponent` from Hotwire. The buttons, inputs and labels map onto `Button`, `Input` and `Label` with a variant; the navigation links have no successor, because the sidebar replaced what used them.

### Fixed

- `kaze install` exits non-zero when it fails. Every step is guarded, so the installer already stopped at the first failure and withheld its success message — but the process still exited 0, so a script or CI job saw a green step over a half-installed application. This is the same class of silent failure as [#11](https://github.com/cuonggt/kaze/issues/11), in the exit code rather than the output. Anything that runs `kaze install` unattended and currently passes over a failure will now fail, which is the point.

### Upgrading

Kaze scaffolds rather than vendors, so nothing changes under an existing application on its own. Re-running `kaze install` over one built with 1.4.0 or earlier does **not** remove what this release replaced — the installer copies files in and never deletes, deliberately, since by then they are yours and may be edited. The replaced files are left behind for you to delete:

| stack | left behind |
|---|---|
| all | `app/controllers/profile_controller.rb`, `app/controllers/password_controller.rb` |
| react, vue | `app/javascript/Components/{PrimaryButton,SecondaryButton,DangerButton,TextInput,InputLabel,Checkbox,Modal,Dropdown,NavLink,ResponsiveNavLink}`, `DropdownLink` on vue, and the whole of `app/javascript/Pages/Profile/` |
| hotwire | `app/components/{nav_link,responsive_nav_link}_component.rb`, `app/views/layouts/_navigation.html.erb`, and the whole of `app/views/profile/` |

On the React stack this is not optional: `tsc` typechecks every file under `app/javascript`, and the stale `Pages/Profile/Edit.tsx` still passes a `header` prop that the layout no longer takes, so the build fails until that directory is gone. Vue and Hotwire build and run with the stale files in place — they are dead weight rather than a break, since nothing routes to them any more.

## [1.4.0] - 2026-10-21

### Added

- An appearance preference — light, dark or system — on the profile page of all three stacks ([#26](https://github.com/cuonggt/kaze/pull/26)). The stubs already carried 315 `dark:` classes, but nothing could reach them: `dark:` followed `prefers-color-scheme`, so an application took whatever the operating system said. The choice is stored in `localStorage`, and system follows the device and tracks it live.

  Each stylesheet now redefines the variant, since Tailwind v4 no longer configures dark mode in JavaScript:

  ```css
  @custom-variant dark (&:where(.dark, .dark *));
  ```

  The layouts apply the resulting `dark` class in an inline `<head>` script before first paint, so the page never flashes the wrong theme. A consequence worth knowing: the theme now depends on JavaScript, so with scripting disabled an application always renders light where it previously followed the operating system.

### Fixed

- Dark mode gaps that were already broken for anyone whose operating system was set to dark, and which the preference control made obvious. React's `AuthenticatedLayout` carried one `dark:` class where Vue's had fifteen, leaving a white navigation bar and header above a dark page; the missing variants are ported from the Vue layout. Four wrappers lacked `dark:bg-gray-900`, leaving a light grey page behind dark cards — hotwire's application layout, React's `AuthenticatedLayout` and `GuestLayout`, and the Inertia ERB wrappers for both stacks.

## [1.3.1] - 2026-10-21

### Changed

- `required_ruby_version` is now `>= 3.4.0`, up from `>= 3.1.0`. Rails 8.1 cannot be parsed by Ruby 3.3 — actionview uses syntax Ruby 3.4 introduced — so a Kaze-scaffolded application has never actually worked below 3.4, and the gem page advertised a floor that the README already contradicted.

## [1.3.0] - 2026-10-21

### Changed

- Both Inertia stacks move to Inertia.js 3 ([#25](https://github.com/cuonggt/kaze/pull/25)). The versions are chained rather than independent: Inertia 3's React adapter requires React 19, and `@vitejs/plugin-react` 6 requires Vite 8, so the whole front end moves together.

  | package | from | to |
  |---|---|---|
  | @inertiajs/react, @inertiajs/vue3 | ^2.0.0 | ^3.9.1 |
  | react, react-dom | ^18.2.0 | ^19.3.1 |
  | @vitejs/plugin-react | ^4.2.0 | ^6.1.2 |
  | @vitejs/plugin-vue | ^5.0.5 | ^6.0.10 |
  | typescript | ^5.6.3 | ^7.0.2 |
  | vite | ^6.4.4 | ^8.3.4 |
  | @types/node | ^18.13.0 | ^26.6.5 |
  | vue | ^3.4.27 | ^3.5.44 |
  | vue-tsc | ^2.0.21 | ^3.3.13 |
  | vite-plugin-rails | ^0.5.0 | ^0.6.0 |

- The React entrypoint resolves pages differently. Inertia 3 narrowed its resolver type so that a promise of a module object is no longer accepted, and `resolvePageComponent` now unwraps `default` itself and is typed with the exported `ResolvedComponent`.

### Added

- Both Inertia stacks install `config/initializers/inertia_rails.rb`. Inertia 3 reads the initial page from a `<script type="application/json">` element and expects a `data-inertia` head attribute; `inertia_rails` supports both but defaults to the v2 behaviour, so without this the client loads and renders nothing. The initializer also sets `always_include_errors_hash`, which becomes the default in InertiaRails 4.0.

### Internal

- Dependabot watches bundler, npm and GitHub Actions weekly. Majors are held back for the two stub manifests, since a major there changes the starter kit and needs an install-and-build pass across all three stacks ([#20](https://github.com/cuonggt/kaze/pull/20))
- The nightly schedule lives in its own workflow ([#19](https://github.com/cuonggt/kaze/pull/19)). GitHub disables a workflow carrying a `schedule:` trigger after 60 days without repository activity, and disables its other triggers with it — which is how CI came to be switched off for the twelve months before 1.2.0. An idle stretch can now cost only the nightly run, never pull request CI.
- `actions/checkout` 4 → 7, prettier 3.3.2 → 3.9.10 ([#21](https://github.com/cuonggt/kaze/pull/21), [#22](https://github.com/cuonggt/kaze/pull/22))

## [1.2.1] - 2026-10-21

No changes to scaffolding behaviour. Packaging, documentation and CI only.

### Added

- This changelog. It ships in the gem and is linked from the RubyGems page through `changelog_uri`

### Changed

- `homepage` and the README point at `github.com/cuonggt/kaze`, the current repository URL, rather than the `gtkvn` name that redirects to it
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

[Unreleased]: https://github.com/cuonggt/kaze/compare/v1.4.0...HEAD
[1.4.0]: https://github.com/cuonggt/kaze/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/cuonggt/kaze/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/cuonggt/kaze/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/cuonggt/kaze/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/cuonggt/kaze/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/cuonggt/kaze/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/cuonggt/kaze/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/cuonggt/kaze/compare/v0.19.0...v1.0.0
