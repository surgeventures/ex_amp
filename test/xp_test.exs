defmodule XPTest do
  use ExUnit.Case
  doctest XP

  test "greets the world" do
    assert XP.hello() == :world
  end
end
