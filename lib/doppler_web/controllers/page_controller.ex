defmodule DopplerWeb.PageController do
  use DopplerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
