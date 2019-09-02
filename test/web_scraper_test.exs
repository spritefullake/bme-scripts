defmodule WebScraperTest do
  use ExUnit.Case
  doctest WebScraper

  @doc """
  The CSV file should have as many columns
  in each row as there are header columns.
  """
  test "csv file conforms to standard" do
    path = Path.absname(WebScraper.aa_file_path())

    stream = path |> File.stream!()

    header_count =
      stream
      |> Stream.take(1)
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.count()

    stream
    |> Stream.with_index()
    |> Enum.each(fn {line, row} ->
      line_count = line |> String.split(",") |> Enum.count()

      if line_count != header_count do
        "Header has #{header_count} columns.
        Row #{row} has #{line_count} columns."
        |> IO.puts()

        assert false
      end
    end)
  end
end
