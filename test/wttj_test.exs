defmodule WTTJTest do
  use ExUnit.Case

  describe "#jobs_from_stream" do
    test "returns a list of jobs" do
      jobs = WTTJ.jobs_from_stream(jobs_stream())

      assert length(jobs) == 4
    end

    test "returns WTTJ.Job structs" do
      job = List.last(WTTJ.jobs_from_stream(jobs_stream()))

      assert %WTTJ.Job{} = job
    end
  end

  describe "#professions_from_stream" do
    test "returns a list of professions" do
      professions = WTTJ.professions_from_stream(professions_stream())

      assert length(professions) == 3
    end

    test "returns WTTJ.Professions structs" do
      profession = List.last(WTTJ.professions_from_stream(professions_stream()))

      assert %WTTJ.Profession{} = profession
    end
  end

  describe "#professions_by_category" do
    test "groups professions by category" do
      keys =
        WTTJ.professions_from_stream(professions_grouping_stream())
        |> WTTJ.professions_by_category()
        |> Map.keys()

      assert keys == ["Conseil", "Tech"]
    end
  end

  defp jobs_stream do
    Path.join(File.cwd!(), "test/fixtures/jobs.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
  end

  defp professions_stream do
    Path.join(File.cwd!(), "test/fixtures/professions.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
  end

  defp professions_grouping_stream do
    Path.join(File.cwd!(), "test/fixtures/professions_grouping.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
  end
end
