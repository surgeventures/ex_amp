# `XP`

[![Build status badge](https://img.shields.io/circleci/project/github/surgeventures/xp/master.svg)](https://circleci.com/gh/surgeventures/surgeventures/xp/tree/master)
[![License badge](https://img.shields.io/github/license/surgeventures/xp.svg)](https://github.com/surgeventures/xp/blob/master/LICENSE.md)
[![Hex version badge](https://img.shields.io/hexpm/v/xp.svg)](https://hex.pm/packages/xp)

**Elixir Pragmatic Package Provisioning**: prepare, release and maintain your Elixir packages like a
pro.

All your code should aim to be top quality, readable, understandable and maintainable throughout its
entire lifecycle. Elixir ecosystem provides many mature, well-thought tools either built right into
the language or closely integrated with it. This includes:

- **compiler** ([mix compile], built-in) - produces compilation warnings that allow to early
  detect bugs & typos in the code eg. an attempt to call non-existing or deprecated function

- **code formatter** ([mix format], built-in) - ensures that all the code follows the same basic
  formatting rules such as maximum number of chars in a line or function indentation

- **code linter** ([Credo]) - ensures that all the code follows a further established set of
  software design, consistency, readability & misc rules and conventions (still statical)

- **documentation generator** ([ExDoc]) - produces documentation compilation errors on issues that
  make it impossible to assemble the docs eg. compilation errors in doc attributes

- **test runner** ([ExUnit], built-in) - starts the application in test mode and runs all runtime
  tests against it (defined as test modules or embedded in docs as doctests)

This exhaustive set of tools gives a deep & thorough end-to-end control over code quality, but it
takes experience to know them and time & effort to set them all up.

XP allows to quickly provision all of these tools in any existing Mix project for instant usage with
an invocation of just a single task - `mix xp.provision`. In addition to making checks available for
local development, XP provides an out-of-the-box CI configuration that runs them in the cloud (free
for open source), providing an instant & reliable indication as to whether released & pull requested
code passes the established quality standards.

There are also following additional tasks available:

- `mix xp.dep` - adds a project dependency with requirement pointing at latest or specified version
- `mix xp.ownership` - manages package ownership on Hex as-a-code

## Installation

Add `xp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xp, "~> 0.1.0"}
  ]
end
```

## Documentation

The docs can be found at [https://hexdocs.pm/xp](https://hexdocs.pm/xp).

[mix compile]: https://hexdocs.pm/mix/Mix.Tasks.Compile.Elixir.html
[mix format]: https://hexdocs.pm/mix/master/Mix.Tasks.Format.html
[Credo]: https://hexdocs.pm/credo
[ExDoc]: https://hexdocs.pm/ex_doc
[ExUnit]: https://hexdocs.pm/ex_unit
