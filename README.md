# XP

**Elixir package provisioning & maintenance on steroids.**

## Installation

Add `xp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xp, "~> 0.1.0"}
  ]
end
```

## Usage

Provision Elixir package with all enhancements (CI, linter, tests, docs...):

    mix xp.gen.all

Provision only specific aspects of your Elixir package:

    mix xp.gen.ci
    mix xp.gen.formatter
    mix xp.gen.credo
    mix xp.gen.clean_compile
    mix xp.gen.docs
    mix xp.gen.tests

Generate a new dependency with requirement pointing at latest or specified version:

    mix xp.gen.dep ecto
    mix xp.gen.dep ecto 3.1.2

List all packages and their owners based on `.ownership.exs`:

    mix xp.ownership list

Sync ownership between `.ownership.exs` and Hex:

    mix xp.ownership apply

## Documentation

The docs can be found at [https://hexdocs.pm/xp](https://hexdocs.pm/xp).

