defmodule HexedioWeb.PageController do
  use HexedioWeb, :controller
  alias Hexedio.Posts
  alias Hexedio.Posts.Post

  def index(conn, _params) do
    render conn, "index.html"
  end

  def blog(conn, params) do
    page = Post
            |> Hexedio.Repo.paginate(params)
    render(conn, "blog.html", posts: page.entries, page: page)
  end

  def blogpost(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "blogpost.html", post: post)
  end

end
