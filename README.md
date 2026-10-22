<p align="center"><img src="/art/logo.svg" alt="Logo Kaze"></p>

# Kaze

Heavily inspired by [Laravel Breeze](https://github.com/laravel/breeze), this gem offers authentication and application starter kits to give you a head start building your new [Rails](https://rubyonrails.org) application. These kits automatically scaffold your application with the routes, controllers, and views you need to register and authenticate your application's users.

[Kaze](https://github.com/cuonggt/kaze) is an opinionated, minimal, simple implementation of all authentication features that a modern web application should have, including login, registration, password reset, and email verification. In addition, Kaze includes a settings area where the user may update their name and email address, change their password, choose an appearance, and delete their account.

Kaze provides scaffolding options based on [Hotwire](https://hotwired.dev) or [Inertia](https://inertiajs.com), with the choice of using Vue or React for the Inertia-based scaffolding.

## Installation

Before creating your first project powered by Kaze, make sure that your local machine has Ruby installed. Ruby can be installed in minutes via [mise](https://mise.jdx.dev).

```
mise use -g ruby@3.4
```

After you have installed Ruby, you may install `rails` and `kaze` gems globally:

```
gem install rails
gem install kaze
```

Kaze is tested against Rails 8.1 on Ruby 3.4. Rails 8.0 is not supported: ActiveSupport 8.0 passes a `quirks_mode:` option to `JSON.generate` that the `json` gem removed in version 3, which breaks session cookies and `js-routes` in any application built on it. The incompatibility is fixed in Rails 8.1.

Then, you may create a new Rails application:

```
rails new kaze-example-app
cd kaze-example-app
```

Once the project has been created, you may scaffold your application using one of the Kaze "stacks" discussed in the documentation below.

## Kaze and Hotwire

The default Kaze "stack" is the Hotwire stack. Hotwire is a powerful way to build dynamic, reactive, front-end UIs primarily using Ruby and ERB templates without using much JavaScript by sending HTML instead of JSON over the wire.

The Hotwire stack may be installed by invoking the `kaze install` command with no other additional arguments inside your app directory. This command publishes the authentication, views, routes, controllers, and other resources to your application.

```
kaze install
```

After Kaze's scaffolding is installed, you may start your application:

```
bin/setup
bin/dev
```

Next, you may navigate to your application's `/login` or `/register` URLs in your web browser. All of Kaze's routes are defined within the `config/routes.rb` file.

## Kaze and React / Vue

Kaze offers React and Vue scaffolding via an Inertia frontend implementation. Inertia allows you to build modern, single-page React and Vue applications using classic server-side routing and controllers.

Inertia lets you enjoy the frontend power of React and Vue combined with the incredible backend productivity of Rails and lightning-fast Vite compilation. To use an Inertia stack, specify `react` or `vue` as your desired stack when executing the `kaze install` command:

```
kaze install react

# Or...

kaze install vue
```

After Kaze's scaffolding is installed, you may start your application:

```
bin/setup
bin/dev
```

Next, you may navigate to your application's `/login` or `/register` URLs in your web browser. All of Kaze's routes are defined within the `config/routes.rb` file.

## The frontend

Both Inertia stacks are built on [shadcn/ui](https://ui.shadcn.com) — thirteen primitives apiece (button, input, label, checkbox, dialog, dropdown menu, separator, skeleton, sheet, tooltip, avatar, breadcrumb and sidebar), on Radix for React and [reka-ui](https://reka-ui.com) for Vue. shadcn copies source into a project rather than shipping a package, which is how Kaze already works, so these land in `app/javascript/Components/ui` and are yours to change.

A `components.json` comes with them, so you can add more:

```
npx shadcn@latest add card
```

One thing to know if you reach for that: Kaze uses a capitalised `@/Components`, which `components.json` already records. The CLI will follow it, but an import you write by hand as `@/components/ui/card` will resolve on macOS and fail on Linux.

Colour runs through design tokens — `bg-background`, `text-muted-foreground`, `border-sidebar-border` and so on, defined once per stylesheet as oklch variables — rather than per-element `dark:` pairs. Appearance is a user preference of light, dark or system, stored in `localStorage` and applied before first paint so the page never flashes the wrong theme; system follows the device and tracks it live. The application layout is a sidebar that collapses to icons and becomes a drawer on small screens, remembering its state in a cookie the server reads back.

There is no shadcn for Hotwire. That stack gets the same look from ViewComponents written against the same tokens, with the handful of [lucide](https://lucide.dev) icons the layouts need inlined into an `IconComponent`, since it carries no npm dependencies at all.

## Upgrading

Kaze copies files into your application and does not own them afterwards, so re-running `kaze install` cannot know whether a file it no longer ships was left over from an older version or written by you. `kaze upgrade` resolves that by asking:

```
kaze upgrade react
```

It lists the files an earlier Kaze installed that this version no longer ships, waits for you to agree, removes them, and then runs the normal install. Only files Kaze itself shipped are ever listed — anything you added alongside them is untouched, and a directory is removed only once it is empty. Pass `--dry-run` to see the list and stop, or `--force` to skip the prompt in a script.

Upgrading from 1.x to 2.x matters on the React stack in particular: `tsc` typechecks every file under `app/javascript`, so the old `Pages/Profile/Edit.tsx` fails the build until it is gone.
