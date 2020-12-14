defmodule WTTJ.Statistics do
  @moduledoc """
  `WTTJ.Statistics` provides functions for job statistics.
  """

  @doc """
  Returns jobs' count by profession category.

  ## Examples

      iex> WTTJ.Statistics.count_by_category(jobs, categories)
      %{
        "Admin" => 3,
      }

  """
  def count_by_category(jobs, categories) do
    jobs_by_category(jobs, categories)
    |> Enum.reduce(%{}, fn {category, jobs}, acc ->
      Map.merge(acc, %{category => length(jobs)})
    end)
  end

  @doc """
  Returns jobs' count by continent.

  ## Examples

      iex> WTTJ.Statistics.count_by_continent(jobs, continents)
      %{
        "Europe" => 3,
      }

  """
  def count_by_continent(jobs, continents) do
    jobs_by_continent(jobs, continents)
    |> Enum.reduce(%{}, fn {continent, jobs}, acc ->
      Map.merge(acc, %{continent => length(jobs)})
    end)
  end

  @doc """
  Returns jobs' count by profession category and continent.

  ## Examples

      iex> WTTJ.Statistics.count_by_category_and_continent(jobs, categories, continents)
      %{
        "Admin" => %{
          "Europe" => 3,
        }
      }

  """
  def count_by_category_and_continent(jobs, categories, continents) do
    jobs_by_category(jobs, categories)
    |> Enum.reduce(%{}, fn {category, jobs}, acc ->
      Map.merge(acc, %{category => count_by_continent(jobs, continents)})
    end)
  end

  @doc """
  Returns jobs grouped by profession category.

  ## Examples

      iex> WTTJ.Statistics.jobs_by_category(jobs, categories)
      %{
        "Admin" => [%WTTJ.Job{}],
      }

  """
  def jobs_by_category(jobs, categories) do
    Enum.reduce(jobs, %{}, fn job, by_categories ->
      case Enum.find(categories, fn {_, professions} ->
             ids = Enum.map(professions, fn profession -> profession.id end)
             job.profession_id in ids
           end) do
        nil -> by_categories
        {category, _} -> add_job_to_category(job, category, by_categories)
      end
    end)
  end

  @doc """
  Returns jobs grouped by continent.

  ## Examples

      iex> WTTJ.Statistics.jobs_by_continent(jobs, continents)
      %{
        "Europe" => [%WTTJ.Job{}],
      }

  """
  def jobs_by_continent(jobs, continents) do
    Enum.reduce(jobs, %{}, fn job, by_continents ->
      case {job.lat, job.lng} do
        {nil, nil} ->
          by_continents

        {lat, lng} ->
          case WTTJ.GeoUtils.continent_for(lat, lng, continents) do
            :not_found -> by_continents
            %{name: continent} -> add_job_to_continent(job, continent, by_continents)
          end
      end
    end)
  end

  defp add_job_to_category(job, category, by_categories) do
    case Map.fetch(by_categories, category) do
      :error -> Map.put_new(by_categories, category, [job])
      {:ok, list} -> %{by_categories | category => [job | list]}
    end
  end

  defp add_job_to_continent(job, continent, by_continents) do
    case Map.fetch(by_continents, continent) do
      :error ->
        Map.put_new(by_continents, continent, [job])

      {:ok, list} ->
        %{by_continents | continent => [job | list]}
    end
  end
end
