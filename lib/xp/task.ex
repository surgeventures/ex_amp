defmodule Xp.Task do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import Mix.Generator
      import unquote(__MODULE__)
    end
  end

  def log_info(output), do: Mix.shell().info(output)

  def log_error(output), do: Mix.shell().error(output)

  def log_step(color, command, message), do: log_info([color, "* #{command} ", :reset, message])
end
