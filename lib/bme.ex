defmodule Bme do
  require WebScraper

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

  def format_nums(str) do
    not_nums = ~r/\D/

    not_nums
    |> Regex.replace(str, ",")
    |> String.split(",")
    |> Enum.filter(fn x -> x != "," && x != "" end)
    |> Enum.map(&Float.parse(&1))
    |> Enum.map(fn {num, _} -> num end)
  end

  def average(nums) do
    Enum.sum(nums) / Enum.count(nums)
  end

  def variance(nums) do
    x_bar = average(nums)

    (nums
     |> Enum.map(fn x -> :math.pow(x - x_bar, 2) end)
     |> Enum.sum()) / (Enum.count(nums) - 1)
  end

  def standard_deviation(nums) do
    nums |> variance |> :math.sqrt()
  end

  def dilute(start, %{:times => t, :by => amount}) do
    start * :math.pow(amount, t)
  end

  def dilute(start, %{:by => amount}) do
    dilute(start, %{:by => amount, :times => 1})
  end

  def p_other(p) do
    14 - p
  end

  @gas_const 8.314

  def delta_g_std(reactants, products, temperature) do
    p = products |> Enum.reduce(1, &(&1 * &2))
    r = reactants |> Enum.reduce(1, &(&1 * &2))
    -1 * @gas_const * temperature * :math.log(p / r)
  end

  def henderson_hasselbach(pKa, pH) do
    :math.pow(10, pH - pKa)
  end

  def henderson_hasselbach(pKa, conj_base, conj_acid) do
    pKa + :math.log10(conj_base / conj_acid)
  end

  def conc_HA(volume, pKa, pH) do
    volume / (1 + henderson_hasselbach(pKa, pH))
  end

  def isoelectric_point(pHs) do
    average(pHs)
  end

  @doc """
  Determines the number of 
  amino acid residues in a simple protein.

  The average weight of a residue is 110 g/mol.

  """
  @spec amino_acid_count(non_neg_integer) :: non_neg_integer
  def amino_acid_count(protein_weight) do
    protein_weight / 110
  end

  def lambert_beer_absorbance(molar_extinction_coefficient, concentration, path_length \\ 1) do
    molar_extinction_coefficient * concentration * path_length
  end

  def count_aa(sequence, pattern) do
    Regex.scan(pattern, sequence) |> Enum.count()
  end

  @doc """
  Count all the negative common AAs (glutamate, aspartate)
  """
  def count_aa_neg(sequence) do
    count_aa(sequence, ~r/D|E/)
  end

  @doc """
  Count all the positive common AAs (arginine, histidine, lysine)
  """
  def count_aa_pos(sequence) do
    count_aa(sequence, ~r/R|H|K/)
  end
end
