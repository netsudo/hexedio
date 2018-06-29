defmodule HexedioWeb.PageController do
  use HexedioWeb, :controller
  import Ecto.Query
  alias Ecto.Query
  alias Hexedio.Posts
  alias Hexedio.Posts.Post
  alias Hexedio.Auth.Guardian

  def index(conn, _params) do
    render conn, "index.html"
  end

  def search(conn, %{"query" => query}) do
    render conn, "index.html"
  end

  def blog(conn, params) do
    page = Post
           |> where([p], p.published == ^true)
           |> Hexedio.Repo.paginate(params)
    render(conn, "blog.html", posts: page.entries, page: page)
  end

  def blogpost(conn, %{"slug" => slug}) do
    maybe_user = Guardian.Plug.current_resource(conn)
    post = if maybe_user != nil do
              Posts.get_post_by_slug!(slug)  
           else
              Posts.get_post_by_slug!(slug, true)
           end

    render(conn, "blogpost.html", post: post)
  end

  def category_page(conn, %{"category" => category}) do
    page = Posts.get_posts_by_category(category) 
    render(conn, "category_page.html", posts: page.entries, page: page)
  end

end
