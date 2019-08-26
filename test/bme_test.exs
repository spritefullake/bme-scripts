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

  test "calculates resulting concentration of dilutions" do
    start = 10
    result = Bme.dilute(start, %{:by => 1/10}) |> Bme.dilute(%{:times => 4, :by => 1/4})
    assert  {0.0039, _} = result 
    |> :erlang.float_to_binary([decimals: 4])
    |> Float.parse
  end

  test "calculates the counterpart to the given pH or pOH value" do
    assert Bme.p_other(5.5) == 8.5
  end

  test "calculates ∆G° given reactants, products, and temperature in kelvin" do
    delta_g_std = Bme.delta_g_std([10.0e-6,15.0e-6], [10.0e-6,10.0e-6], 25 + 273)
    assert Kernel.round(delta_g_std/10) * 10 == 1000
  end

  @doc "remember pH = pKa + log([A-]/[HA])"
  test "henderson-hasselbach solved for pH" do
    assert Bme.henderson_hasselbach(7,12,12) == 7
  end
  test "henderson-hasselbach solved for [A-]/[HA]" do
    assert Bme.henderson_hasselbach(6,5) == 0.1
  end

  test "find concentration of [HA] given volume" do
    conc = Bme.conc_HA(0.1,6.86,7)
    assert Kernel.round(conc*100) == 4
  end

  test "find the isoelectric point (isoelectric pH) for an amino acid" do
    pHs = [2.34, 9.60]
    assert Bme.isoelectric_point(pHs) == 5.97
  end

end
