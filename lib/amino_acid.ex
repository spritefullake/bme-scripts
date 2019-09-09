defmodule AminoAcid do
  alias NimbleCSV.RFC4180, as: CSV

  defstruct [
    :name,
    :long_code,
    :short_code,
    :molecular_weight,
    :molecular_formula,
    :residue_formula,
    :residue_weight,
    :pK1,
    :pK2,
    :pKR,
    :pI
  ]

  @doc """
  pre: input file is in correct CSV format
  """
  def parse_file(path) do
    to_float = fn x ->
      case Float.parse(x) do
        {number, _} -> number
        :error -> nil
      end
    end

    path
    |> File.stream!()
    |> CSV.parse_stream()
    |> Stream.map(fn [
                       name,
                       long_code,
                       short_code,
                       molecular_weight,
                       molecular_formula,
                       residue_formula,
                       residue_weight,
                       pK1,
                       pK2,
                       pKR,
                       pI
                     ] ->
      %__MODULE__{
        name: name,
        short_code: short_code,
        long_code: long_code,
        molecular_weight: molecular_weight |> to_float.(),
        molecular_formula: molecular_formula,
        residue_weight: residue_weight |> to_float.(),
        residue_formula: residue_formula,
        pK1: pK1 |> to_float.(),
        pK2: pK2 |> to_float.(),
        pKR: pKR |> to_float.(),
        pI: pI |> to_float.()
      }
    end)
    |> Enum.to_list()
  end

  def parse_file() do
    parse_file(WebScraper.aa_file_path())
  end

  def split(seq) do
    hyphen = ~r/-/
    camel_case = ~r/([A-Z][a-z][a-z])/
    letter = ~r/[A-Z]/

    cond do
      hyphen |> Regex.match?(seq) -> seq |> String.split("-")
      camel_case |> Regex.match?(seq) -> split(camel_case, seq)
      true -> split(letter, seq)
    end
  end

  defp split(pattern, seq) do
    pattern
    |> Regex.split(seq,
      include_captures: true,
      trim: true
    )
  end

  def counts(amino_acids) do
    increment_count =
      &Map.update(&1, &2, 1, fn count -> count + 1 end)
      # if there is no key for the given amino acid yet
      # in the map, then the initial count will be 1 if
      # the amino acid is encountered

    amino_acids |> Enum.reduce(%{}, &increment_count.(&2, &1))
  end

  def z(p1, p2) do
    (p2 - 1) / (p2 - p1)
  end

  def m(p1, p2) do
    (p2 - 1) * (p1 - 1) / (p2 - p1)
  end
end
