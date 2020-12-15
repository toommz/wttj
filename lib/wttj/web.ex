defmodule WTTJ.Web do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: WTTJ.Web.Router, options: [port: 3000]}
    ]

    opts = [strategy: :one_for_one, name: WTTJ.Web.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
