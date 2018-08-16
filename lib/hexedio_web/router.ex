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
    pipe_through [:browser, :auth] 

    get "/", PageController, :index
    get "/blog", PageController, :blog
    get "/blog/:slug", PageController, :blogpost
    get "/blog/search/query", PageController, :search
    get "/blog/category/:category", PageController, :category_page

    get "/login", AuthController, :login
    post "/login_handler", AuthController, :login_handler
    post "/logout", AuthController, :logout

    get "/contact", PageController, :contact
    get "/contact_handler", PageController, :contact_handler
  end

  scope "/", HexedioWeb do
    pipe_through [:browser, :auth, :ensure_auth] 
    
    resources "/post", PostController
    resources "/categories", CategoryController
  end

end
