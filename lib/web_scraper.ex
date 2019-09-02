defmodule WebScraper do
  @moduledoc """
  Scrapes, obtains, and properly formats data into files
  """
  @amino_acids_url "https://www.sigmaaldrich.com/life-science/metabolomics/learning-center/amino-acid-reference-chart.html"
  @common_aa_count 22
  @aa_file_path "lib/amino_acid_data.csv"
  def store_amino_acids do
    html = scrape_amino_acids()

    [headings | data] = html |> Floki.find(".productTable  tr")

    [format_chemical_headings(headings), "\n", format_table_data(data)]
    |> write_to_file(@aa_file_path)
  end

  def scrape_amino_acids do
    case HTTPoison.get(@amino_acids_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Error retrieving amino acid data!")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  @doc """
  both format_ functions output in CSV format
  """
  defp format_table_data(data) do
    # Prevents internal separation of Chemical Formulas comma-wise 
    data
    |> Enum.map(fn tr ->
      tr
      |> Floki.find("td")
      |> Enum.map(&Floki.text/1)
      |> Floki.text(sep: ",")
    end)
    |> Enum.take(@common_aa_count)
    |> Enum.map(&String.trim/1)
    |> Enum.join("\n")
  end

  defp format_chemical_headings(headings) do
    headings
    |> Floki.find("td")
    |> Enum.map(fn td -> Regex.replace(~r/[^\w]/, td |> Floki.text(), "") end)
    |> Enum.join(",")
  end

  defp write_to_file(data, name) do
    path = Path.absname(name)

    case File.write(path, data) do
      :ok ->
        IO.puts(["Successfully wrote data to ", path])

      {:error, reason} ->
        IO.puts(["There was an error because: ", reason])
    end
  end
end
