defmodule WTTJ.Web.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/jobs" do
    query = Plug.Conn.Query.decode(conn.query_string)

    case get_jobs() |> WTTJ.Search.jobs(query) do
      :error ->
        send_resp(conn, 400, "bad request")

      {:ok, jobs} ->
        put_resp_content_type(conn, "application/json")
        |> send_resp(200, Poison.encode!(jobs))
    end
  end

  match _ do
    send_resp(conn, 404, "Unknown route")
  end

  defp get_jobs do
    Path.join(File.cwd!(), "db/jobs.csv")
    |> File.stream!()
    |> CommaSepatorParser.parse_stream()
    |> WTTJ.jobs_from_stream()
  end
end
