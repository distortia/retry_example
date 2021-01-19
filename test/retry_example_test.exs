defmodule RetryExampleTest do
  use ExUnit.Case
  doctest RetryExample

  test "greets the world" do
    assert RetryExample.hello() == :world
  end
end
