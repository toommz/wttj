defmodule WTTJ.CLI do
  def main([]) do
    continents =
      Path.join(File.cwd!(), "db/continents.csv")
      |> File.stream!()
      |> SemicolonSepatorParser.parse_stream()
      |> WTTJ.GeoUtils.continents_from_stream()

    jobs =
      Path.join(File.cwd!(), "db/jobs.csv")
      |> File.stream!()
      |> CommaSepatorParser.parse_stream()
      |> WTTJ.jobs_from_stream()

    professions_by_category =
      Path.join(File.cwd!(), "db/professions.csv")
      |> File.stream!()
      |> CommaSepatorParser.parse_stream()
      |> WTTJ.professions_from_stream()
      |> WTTJ.professions_by_category()

    jobs_by_category_and_continent =
      WTTJ.Statistics.count_by_category_and_continent(jobs, professions_by_category, continents)

    jobs_by_category = WTTJ.Statistics.count_by_category(jobs, professions_by_category)

    headers = ["" | ["Total" | Map.keys(jobs_by_category)]]
    total_row = ["Total" | [length(jobs) | Map.values(jobs_by_category)]]
    rows = [total_row | prepare_rows(jobs_by_category_and_continent, Map.keys(jobs_by_category))]

    TableRex.quick_render!(rows, headers)
    |> IO.puts()
  end

  defp prepare_rows(jobs, categories) do
    Enum.map(jobs, fn {continent, data} ->
      stats =
        Enum.map(categories, fn category ->
          case Map.fetch(data, category) do
            :error -> 0
            {:ok, count} -> count
          end
        end)

      [continent | [Enum.reduce(data, 0, fn {_, count}, acc -> acc + count end) | stats]]
    end)
  end
end
