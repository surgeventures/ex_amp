defmodule ExAmp.Provision.CI do
  @moduledoc false

  use ExAmp.Task

  @config_path ".circleci/config.yml"

  @config_default """
  version: 2
  jobs:
    build:
      docker:
        - image: circleci/elixir
      environment:
        - MIX_ENV: test
      working_directory: ~/repo
      steps:
        - checkout
        - run: mix local.hex --force
        - run: mix local.rebar --force
        - run: mix deps.get
  """

  def present? do
    File.exists?(@config_path)
  end

  def gen do
    if match?(:ok, create_file(@config_path, @config_default)) do
      log_info([
        :yellow,
        "CircleCI config generated  - please add your project on https://circleci.com"
      ])
    end
  end

  def add_task(task) do
    log_step(:green, "adding task", task)

    task_step = "run: #{task}"

    with {_, {:ok, content}} <- {:read_config, File.read(@config_path)},
         lines = String.split(content, "\n"),
         {_, {:ok, steps, insert_at}} <- {:parse_build_steps, parse_ci_config_build_steps(lines)},
         {_, false} <- {:already_added, Enum.any?(steps, &(&1 == task_step))} do
      new_content =
        lines
        |> List.insert_at(insert_at, "      - " <> task_step)
        |> Enum.join("\n")

      File.write!(@config_path, new_content)

      {:ok, :added}
    else
      {:read_config, _} -> {:error, :read_config}
      {:parse_build_steps, _} -> {:error, :parse_build_steps}
      {:already_added, _} -> {:ok, :already_added}
    end
    |> case do
      {:error, :read_config} ->
        log_error("No CI config - please generate it via `mix amp.provision`")

      {:error, :parse_build_steps} ->
        log_error("Unable to modify CI config - please add task `#{task}` manually")

      {:ok, _} ->
        nil
    end
  end

  defp parse_ci_config_build_steps(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(:top, fn
      {"jobs:", _}, :top ->
        :jobs

      {"  build:", _}, :jobs ->
        :build_job

      {"    steps:", _}, :build_job ->
        {:build_job_steps, []}

      {"      - " <> step, _}, {:build_job_steps, steps} ->
        {:build_job_steps, [step | steps]}

      {_, ends_at}, {:build_job_steps, steps} ->
        {:ok, Enum.reverse(steps), ends_at}

      _, acc ->
        acc
    end)
    |> case do
      {:ok, _, _} = acc -> acc
      _ -> :error
    end
  end
end
