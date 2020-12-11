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

  defp jobs_stream do
    Path.join(File.cwd!(), "test/fixtures/jobs.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
  end
end
