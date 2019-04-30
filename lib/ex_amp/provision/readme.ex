defmodule ExAmp.Provision.Readme do
  @moduledoc false

  use ExAmp.Task
  alias ExAmp.Project
  alias ExAmp.Provision.CI

  @path "README.md"

  embed_template(:content, """
  # <%= @name %>

  **<%= @description %>**

  <% if @package? do %>
  ## Installation

  Add `<%= @app %>` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:<%= @app %>, "~> <%= @version %>"}
    ]
  end
  ```

  ## Documentation

  The docs can be found at [https://hexdocs.pm/<%= @app %>](https://hexdocs.pm/<%= @app %>).
  <% end %>
  """)

  def gen do
    project_config = Mix.Project.config()
    app = Keyword.fetch!(project_config, :app)
    name = Keyword.get(project_config, :name, app)
    description = Keyword.get(project_config, :description, "TODO: Add description")
    package? = Keyword.has_key?(project_config, :package)
    version = Keyword.fetch!(project_config, :version)

    unless package? do
      log_info([:yellow, "No package config - please add `package: [...]` to project config"])
    end

    content =
      content_template(
        app: app,
        name: name,
        description: description,
        package?: package?,
        version: version
      )

    create_file(@path, content)

    add_badge(:license)
    add_badge(:ci)
    add_badge(:hex)
  end

  def add_badge(:license) do
    if repo_path = Project.github_repo_path() do
      image_url = "https://img.shields.io/github/license/#{repo_path}.svg"
      details_url = "https://github.com/#{repo_path}/blob/master/LICENSE.md"
      label = "License badge"

      do_add_badge(image_url, details_url, label)
    end
  end

  def add_badge(:hex) do
    if Project.package?() do
      app = Project.app()

      image_url = "https://img.shields.io/hexpm/v/#{app}.svg"
      details_url = "https://hex.pm/packages/#{app}"
      label = "Hex version badge"

      do_add_badge(image_url, details_url, label)
    end
  end

  def add_badge(:ci) do
    with true <- CI.present?(),
         repo_path <- Project.github_repo_path() do
      image_url = "https://img.shields.io/circleci/project/github/#{repo_path}/master.svg"
      details_url = "https://circleci.com/gh/surgeventures/#{repo_path}/tree/master"
      label = "Build status badge"

      do_add_badge(image_url, details_url, label)
    end
  end

  defp do_add_badge(image_url, details_url, label) do
    with {_, {:ok, content}} <- {:read_config, File.read(@path)},
         lines = String.split(content, "\n"),
         {_, {:ok, badges, insert_at}} <- {:parse_badges, parse_badges(lines)},
         {_, false} <- {:already_added, Enum.member?(badges, label)} do
      badge_text = "[![#{label}](#{image_url})](#{details_url})"

      lines =
        if insert_at do
          List.insert_at(lines, insert_at + 1, badge_text)
        else
          lines
          |> List.insert_at(1, "")
          |> List.insert_at(2, badge_text)
        end

      new_content = Enum.join(lines, "\n")
      File.write!(@path, new_content)

      {:ok, :added}
    else
      {:already_added, _} -> {:ok, :already_added}
      {:parse_badges, _} -> {:error, :parse_badges}
    end
  end

  defp parse_badges(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(:top, fn
      {"#" <> _, _}, :top ->
        :title

      {_, _}, :top ->
        :error

      {"", _}, :title ->
        {:badges, [], nil}

      {"[![" <> label_eol, ends_at}, {:badges, badges, _} ->
        label = label_eol |> String.split("]") |> List.first()
        {:badges, [label | badges], ends_at}

      {_, _}, {:badges, badges, ends_at} ->
        {:ok, Enum.reverse(badges), ends_at}

      _, acc ->
        acc
    end)
    |> case do
      {:ok, _, _} = acc -> acc
      _ -> :error
    end
  end
end
