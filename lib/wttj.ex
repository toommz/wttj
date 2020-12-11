defmodule WTTJ do
  NimbleCSV.define(SemicolonSepatorParser, separator: ";")
  NimbleCSV.define(CommaSepatorParser, separator: ",")

  defmodule Job do
    defstruct [:profession_id, :contract_type, :name, :lat, :lng]
  end

  defmodule Profession do
    defstruct [:id, :name, :category_name]
  end

  @moduledoc """
  Documentation for `WTTJ`.
  """

  @doc """
  Returns jobs from a stream.

  ## Examples

      iex> WTTJ.jobs_from_stream(Stream)
      [
        %{profession_id: 1, contract_type: "INTERSHIP", name: "Architecte", lat: Float, lng: Float}
      ]

  """
  def jobs_from_stream(stream) do
    Stream.map(stream, fn [profession_id, contract_type, name, lat, lng] ->
      %Job{
        profession_id: parse_value(profession_id, Integer),
        contract_type: contract_type,
        name: name,
        lat: parse_value(lat, Float),
        lng: parse_value(lng, Float)
      }
    end)
    |> Enum.to_list()
  end

  @doc """
  Returns professions from a stream.

  ## Examples

      iex> WTTJ.professions_from_stream(Stream)
      [
        %{id: 1, name: "Wholesale", category_name: "Retail"}
      ]

  """
  def professions_from_stream(stream) do
    Stream.map(stream, fn [id, name, category_name] ->
      %Profession{
        id: parse_value(id, Integer),
        name: name,
        category_name: category_name
      }
    end)
    |> Enum.to_list()
  end

  defp parse_value(raw_value, module) do
    case module.parse(raw_value) do
      {value, _} -> value
      :error -> nil
    end
  end
end
