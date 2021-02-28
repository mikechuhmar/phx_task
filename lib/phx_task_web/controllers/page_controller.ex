defmodule PhxTaskWeb.PageController do
  use PhxTaskWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
