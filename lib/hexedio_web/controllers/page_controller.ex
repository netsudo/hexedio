defmodule HexedioWeb.PageController do
  use HexedioWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
