defmodule WTTJ.StatisticsTest do
  use ExUnit.Case

  describe "#jobs_by_category" do
    test "returns a map with expected keys" do
      stats = WTTJ.Statistics.jobs_by_category(jobs(), professions_by_category())

      assert %{"Conseil" => _, "Tech" => _} = stats
    end

    test "returns a map with expected values type" do
      stat =
        WTTJ.Statistics.jobs_by_category(jobs(), professions_by_category())
        |> Map.fetch!("Conseil")
        |> List.first()

      assert %WTTJ.Job{} = stat
    end
  end

  describe "#jobs_by_continent" do
    test "returns a map with expected keys" do
      stats = WTTJ.Statistics.jobs_by_continent(jobs(), continents())

      assert %{"Antartica" => _, "South America" => _} = stats
    end

    test "returns a map with expected values type" do
      stat =
        WTTJ.Statistics.jobs_by_continent(jobs(), continents())
        |> Map.fetch!("South America")
        |> List.first()

      assert %WTTJ.Job{} = stat
    end

    test "returns a map with expected values" do
      count =
        WTTJ.Statistics.jobs_by_continent(jobs(), continents())
        |> Map.fetch!("South America")
        |> length()

      assert count == 3
    end
  end

  describe "#count_by_category" do
    test "returns a map with expected keys" do
      stats = WTTJ.Statistics.count_by_category(jobs(), professions_by_category())

      assert %{"Conseil" => _, "Tech" => _} = stats
    end

    test "returns a map with expected values" do
      stat =
        WTTJ.Statistics.count_by_category(jobs(), professions_by_category())
        |> Map.fetch!("Conseil")

      assert stat == 3
    end
  end

  describe "#count_by_continent" do
    test "returns a map with expected keys" do
      stats = WTTJ.Statistics.count_by_continent(jobs(), continents())

      assert %{"Antartica" => _, "South America" => _} = stats
    end

    test "returns a map with expected values" do
      stat =
        WTTJ.Statistics.count_by_continent(jobs(), continents())
        |> Map.fetch!("South America")

      assert stat == 3
    end
  end

  describe "#count_by_category_and_continent" do
    test "returns a map with expected keys" do
      stats =
        WTTJ.Statistics.count_by_category_and_continent(
          jobs(),
          professions_by_category(),
          continents()
        )

      assert %{"Antartica" => _, "South America" => _} = stats
    end

    test "returns a map with expected values" do
      stat =
        WTTJ.Statistics.count_by_category_and_continent(
          jobs(),
          professions_by_category(),
          continents()
        )
        |> Map.fetch!("South America")

      assert stat == %{"Conseil" => 3}
    end
  end

  defp jobs do
    Path.join(File.cwd!(), "test/fixtures/jobs_statistics.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
    |> WTTJ.jobs_from_stream()
  end

  defp professions_by_category do
    Path.join(File.cwd!(), "test/fixtures/professions_grouping.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
    |> WTTJ.professions_from_stream()
    |> WTTJ.professions_by_category()
  end

  defp continents do
    Path.join(File.cwd!(), "test/fixtures/continents.csv")
    |> File.stream!()
    |> SemicolonSepatorParser.parse_stream()
    |> WTTJ.GeoUtils.continents_from_stream()
  end
end
