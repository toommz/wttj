defmodule WTTJ.GeoUtilsTest do
  use ExUnit.Case
  doctest WTTJ

  def stream do
    Path.join(File.cwd!(), "test/fixtures/continents.csv")
    |> File.stream!()
    |> SemicolonSepatorParser.parse_stream()
  end

  test "returns a list of continents with their geo shapes" do
    # assert WTTJ.hello() == :world
    continents = WTTJ.GeoUtils.continents_from_stream(stream())

    assert length(continents) == 2
  end

  test "returns an Antartica continent with its associated geo shape" do
    antartica =
      Enum.find(WTTJ.GeoUtils.continents_from_stream(stream()), fn continent ->
        continent.name == "Antartica"
      end)

    assert %Geo.Polygon{} = antartica.geo_shape
  end

  test "returns a South America continent with its associated geo shape" do
    south_america =
      Enum.find(WTTJ.GeoUtils.continents_from_stream(stream()), fn continent ->
        continent.name == "South America"
      end)

    assert %Geo.Polygon{} = south_america.geo_shape
  end
end
