defmodule WTTJ do
  NimbleCSV.define(SemicolonSepatorParser, separator: ";")
  NimbleCSV.define(CommaSepatorParser, separator: ",")

  defmodule Job do
    defstruct [:profession_id, :contract_type, :name, :lat, :lng]
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

  defp parse_value(raw_value, module) do
    case module.parse(raw_value) do
      {value, _} -> value
      :error -> nil
    end
  end
end
