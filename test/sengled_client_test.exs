defmodule SengledClientTest do
  use ExUnit.Case
  doctest SengledClient

  test "greets the world" do
    assert SengledClient.hello() == :world
  end
end
