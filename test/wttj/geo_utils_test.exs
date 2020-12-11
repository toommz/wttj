defmodule WTTJ.GeoUtilsTest do
  use ExUnit.Case
  doctest WTTJ

  describe "#continents_from_stream" do
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

  describe "#continent_for" do
    test "returns South America when given a latitude and longitude in Brazil" do
      continents = WTTJ.GeoUtils.continents_from_stream(stream())

      assert %{name: "South America", geo_shape: %Geo.Polygon{}} =
               WTTJ.GeoUtils.continent_for(-22.9139573, -43.5160212, continents)
    end

    test "returns %{:not_found} when the location does not belong to any continent" do
      continents = WTTJ.GeoUtils.continents_from_stream(stream())

      assert {:not_found} = WTTJ.GeoUtils.continent_for(48.8666863, 2.3426808, continents)
    end
  end

  defp stream do
    Path.join(File.cwd!(), "test/fixtures/continents.csv")
    |> File.stream!()
    |> SemicolonSepatorParser.parse_stream()
  end
end
