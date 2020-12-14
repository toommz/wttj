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

  @doc """
  Return the continent for the given location.

  ## Examples

      iex> WTTJ.GeoUtils.continent_for(Float, Float, List)
      %{name: "Europe", geo_shape: %Geo.Polygon%{coordinates: […]}}

  """
  def continent_for(lat, lng, continents) do
    case find_continent(geo_point_from_lat_lng(lat, lng), continents) do
      nil -> :not_found
      continent -> continent
    end
  end

  defp decode_geojson_shape(geo_shape) do
    Poison.decode!(geo_shape)
    |> Geo.JSON.decode!()
  end

  defp geo_point_from_lat_lng(lat, lng) do
    %Geo.Point{coordinates: {lng, lat}}
  end

  defp find_continent(point, continents) do
    Enum.find(continents, fn continent ->
      Topo.contains?(continent.geo_shape, point)
    end)
  end
end
