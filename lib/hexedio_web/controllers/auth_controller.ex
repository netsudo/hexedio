defmodule HexedioWeb.AuthController do
  use HexedioWeb, :controller
  alias Hexedio.Auth
  alias Hexedio.Auth.User
  alias Hexedio.Auth.Guardian

  def login(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    message = if maybe_user != nil do
      "Someone is logged in"
    else
      "No one is logged in"
    end

    conn 
      |> put_flash(:info, message)
      |> render("login.html", changeset: changeset, action:
                auth_path(conn, :login_handler), maybe_user: maybe_user)
  end

  def login_handler(conn, %{"user" => %{"username" => username, "password"
                    => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: auth_path(conn, :login))
  end

end
