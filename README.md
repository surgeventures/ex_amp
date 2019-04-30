# ExAmp

[![License badge](https://img.shields.io/github/license/surgeventures/ex_amp.svg)](https://github.com/surgeventures/ex_amp/blob/master/LICENSE.md)
[![Build status badge](https://img.shields.io/circleci/project/github/surgeventures/ex_amp/master.svg)](https://circleci.com/gh/surgeventures/surgeventures/ex_amp/tree/master)
[![Hex version badge](https://img.shields.io/hexpm/v/ex_amp.svg)](https://hex.pm/packages/ex_amp)

**Elixir Project Amplifier**: supercharge your Elixir project setup and maintenance.

## Installation

Add `ex_amp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_amp, "~> 0.1.0"}
  ]
end
```

## Usage

### `mix amp.provision`

*Provisions Elixir package with all or specified enhancements.*

All your code should aim to be top quality, readable, understandable and maintainable throughout
its entire lifecycle. Elixir ecosystem provides many mature, well-thought tools either built right
into the language or closely integrated with it. This includes:

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

This task allows to quickly provision all of these tools in any existing Mix project for instant
usage with an invocation of just a single task - `mix ex_amp.provision`. In addition to making
checks available for local development, this task provides an out-of-the-box CI configuration that
runs them in the cloud (free for open source), providing an instant & reliable indication as to
whether released & pull requested code passes the established quality standards.

### `mix amp.deps.add`

*Adds latest version(s) of specified dep(s) to the project.*

Adding dependencies to Elixir project comes down to a simple task of inserting a tuple with package
name and semantic version requirement string to the project configuration. Usually though, you'll
want to add latest version of Hex package to the project and allow non-breaking changes. This
requires checking the latest versions on Hex and manually adding the requirements. Such process can
get time consuming especially when adding multiple deps.

This task automates the whole process and allows quick (amd possibly batch) addition of deps to the
project.

### `mix amp.ownership`

*Manages package ownership on Hex as a code.*

When the organization active with Elixir open source releases on Hex grows with more maintainers and
growing number of packages, it may become a time consuming and error prone task to manage the
package ownership. This task solves this problem by allowing to manage the ownership as a code.

*Ownership file* serves the purpose of the source of truth. It should be a valid Elixir script that
should evaluate into a list of `{package_name, owner_email}` tuples and it defaults to
`.ownership.exs`.

## Documentation

The docs can be found at [https://hexdocs.pm/ex_amp](https://hexdocs.pm/ex_amp). You can also access
the complete usage information of each task by invoking `mix help <task>`.
