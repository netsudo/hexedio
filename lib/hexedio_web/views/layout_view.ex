defmodule HexedioWeb.LayoutView do
  use HexedioWeb, :view
  alias Hexedio.Auth.Guardian
  alias Hexedio.Posts

  def maybe_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def categories() do
    Posts.list_categories
  end

end
