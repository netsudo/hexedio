defmodule HexedioWeb.Router do
  use HexedioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Hexedio.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", HexedioWeb do
    pipe_through [:browser, :auth,] # Use the default browser stack

    get "/", PageController, :index
    get "/login", PageController, :login
    resources "/posts", PostController
    post "/login", PageController, :login_handler
    post "/logout", PageController, :logout

  end

end
