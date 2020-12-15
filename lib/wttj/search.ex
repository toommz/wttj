defmodule WTTJ.Search do
  @doc """
  Based on the query argument, returns:
    - all jobs
    - jobs filtered on one attribute
    - jobs filtered on two or more attributes

  ## Examples

      iex> WTTJ.Search.jobs(jobs, %{})
      [
        %WTTJ.Job{},
      ]

      iex> WTTJ.Search.jobs(jobs, %{name: "engineer"})
      [
        %WTTJ.Job{},
      ]

      iex> WTTJ.Search.jobs(jobs, %{name: "engineer", profession: 14})
      [
        %WTTJ.Job{},
      ]

  """
  def filtered_jobs(jobs, query) when query == %{} do
    {:ok, jobs}
  end

  def jobs(jobs, query) when map_size(query) == 1 do
    case Enum.all?(Map.keys(query), fn key -> key in permitted_params() end) do
      true -> {:ok, filter_jobs(jobs, query)}
      false -> :error
    end
  end

  def jobs(jobs, query) do
    case Enum.all?(Map.keys(query), fn key -> key in permitted_params() end) do
      true -> {:ok, multi_filter_jobs(jobs, query)}
      false -> :error
    end
  end

  defp multi_filter_jobs(jobs, query) do
    filter_jobs(jobs, query)
    |> Enum.reduce({%{}, %{}}, fn job, {elems, dupes} ->
      case Map.has_key?(elems, job) do
        true -> {elems, Map.put(dupes, job, nil)}
        false -> {Map.put(elems, job, nil), dupes}
      end
    end)
    |> elem(1)
    |> Map.keys()
  end

  defp filter_jobs(jobs, query) do
    Enum.flat_map(query, fn {filter, value} ->
      apply(WTTJ.Search, :"filter_by_#{filter}", [jobs, value])
    end)
  end

  def filter_by_name(data, value) do
    regex = Regex.compile!(value)

    Enum.filter(data, fn job ->
      String.match?(job.name, regex)
    end)
  end

  def filter_by_profession(data, value) do
    Enum.filter(data, fn job ->
      job.profession_id == String.to_integer(value)
    end)
  end

  defp permitted_params do
    ["name", "profession"]
  end
end
