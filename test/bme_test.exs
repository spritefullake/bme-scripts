defmodule BmeTest do
  use ExUnit.Case
  doctest Bme

  test "greets the world" do
    assert Bme.hello() == :world
  end

  test "formats a list of numbers from a text into a list of numbers" do
    assert Bme.format_nums("3, 1, 0, 4, and 7") == [3,1,0,4,7]
  end

  test "calculates the average of a list of numbers" do
    assert Bme.average([3,1,0,4,7]) == 3
  end

  test "calculates the variance" do
    assert Bme.variance([3,1,0,4,7]) == 7.5
  end

  test "calculates the standard deviation" do
    assert {2.74, _} = 
    Bme.standard_deviation([3,1,0,4,7]) 
    |> :erlang.float_to_binary([decimals: 2])
    |> Float.parse
  end
end
