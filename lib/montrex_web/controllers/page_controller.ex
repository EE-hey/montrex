defmodule MontrexWeb.PageController do
  use MontrexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
