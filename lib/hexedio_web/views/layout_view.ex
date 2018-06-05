defmodule HexedioWeb.LayoutView do
  use HexedioWeb, :view
  alias Hexedio.Auth.Guardian

  def maybe_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

end
