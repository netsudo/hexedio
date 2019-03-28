defmodule HexedioWeb.AuthController do
  use HexedioWeb, :controller
  alias Hexedio.Auth
  alias Hexedio.LoginAttempt
  alias Hexedio.Auth.{User, Guardian}

  def login(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    conn 
    |> render("login.html", changeset: changeset, action:
              auth_path(conn, :login_handler), maybe_user: maybe_user)
  end

  def login_handler(conn, %{"user" => %{"username" => username, "password" => password}}) do
    LoginAttempt.make(username)
    {attempts, _} = LoginAttempt.get(username)
    if attempts > 5 do
      login_reply({:error, "Too many login attempts."}, conn)
    else
      Auth.authenticate_user(username, password)
      |> login_reply(conn)
    end
  end

  defp login_reply({:error, error}, conn) do
    IO.inspect error
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/post")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: auth_path(conn, :login))
  end
end
