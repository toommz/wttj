defmodule WTTJ.GeoUtils do
  @moduledoc """
  `WTTJ.GeoUtils` contains useful geolocation utilities for the app requirements.
  """

  @doc """
  Takes a stream containing GeoJSON data (2 columns, [geo_shape, continent_name]).

  ## Examples

      iex> WTTJ.GeoUtils.continents_from_stream(Stream)
      [
        %{name: "Europe", geo_shape: %Geo.Polygon%{coordinates: […]}}
      ]

  """
  def continents_from_stream(stream) do
    Stream.map(stream, fn [geo_shape, continent_name] ->
      %{name: continent_name, geo_shape: decode_geojson_shape(geo_shape)}
    end)
    |> Enum.to_list()
  end

  defp decode_geojson_shape(geo_shape) do
    geojson = Poison.decode!(geo_shape)
    Geo.JSON.decode!(geojson)
  end
end
