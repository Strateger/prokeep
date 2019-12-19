defmodule ProkeepqWeb.PageController do
  use ProkeepqWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
