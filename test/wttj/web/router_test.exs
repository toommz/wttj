defmodule WTTJ.Web.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias WTTJ.Web.Router

  @opts Router.init([])

  test "returns 200" do
    conn =
      :get
      |> conn("/jobs", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns jobs as JSON" do
    conn =
      :get
      |> conn("/jobs?name=développeur", "")
      |> Router.call(@opts)

    parsed_body = Poison.decode!(conn.resp_body)

    assert %{"profession_id" => _, "name" => _, "lat" => _, "lng" => _, "contract_type" => _} =
             List.first(parsed_body)
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
