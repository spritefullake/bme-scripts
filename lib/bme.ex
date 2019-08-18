defmodule Bme do
  @moduledoc """
  Documentation for Bme.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Bme.hello()
      :world

  """
  def hello do
    :world
  end

  def format_nums str do
    not_nums = ~r/\D/
    not_nums |> Regex.replace(str,",") 
    |> String.split(",") 
    |> Enum.filter(fn x -> x != "," && x != "" end)
    |> Enum.map(&(Float.parse &1)) 
    |> Enum.map(fn {num, _} -> num end)

  end
  def average nums do
    Enum.sum(nums) / Enum.count(nums)
  end
  def variance nums do
    x_bar = average nums
    (nums 
    |> Enum.map(fn x -> :math.pow(x - x_bar,2) end)
    |> Enum.sum) / (Enum.count(nums) - 1)
  end
  def standard_deviation nums do
    nums |> variance |> :math.sqrt 
  end
end
