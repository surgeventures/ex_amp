defmodule XP do
  @moduledoc """
  Documentation for XP.
  """

  def dep(mix_path, dep) do
    mix_lines = File.read!(mix_path) |> String.split("\n")
    deps_begin = Enum.find_index(mix_lines, &(&1 == "  defp deps do"))
    {pre_deps_lines, deps_eof_lines} = Enum.split(mix_lines, deps_begin + 1)
    deps_end = Enum.find_index(deps_eof_lines, &(&1 == "  end"))
    {deps_lines, post_deps_lines} = Enum.split(deps_eof_lines, deps_end)
    deps_string = Enum.join(deps_lines, "\n")
    {deps, _} = Code.eval_string(deps_string)

    dep_name = elem(dep, 0)
    existing_dep = List.keyfind(deps, dep_name, 0)

    unless existing_dep do
      new_deps = deps ++ [dep]

      new_deps_string =
        new_deps
        |> Macro.escape()
        |> Macro.to_string()
        |> String.replace(~r/^\[/, "[\n")
        |> String.replace(~r/\]$/, "\n]")

      new_mix_lines = pre_deps_lines ++ [new_deps_string] ++ post_deps_lines
      new_mix = new_mix_lines |> Enum.join("\n") |> Code.format_string!()

      IO.puts(new_mix)
    end

    deps
  end
end
