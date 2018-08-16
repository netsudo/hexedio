defmodule HexedioWeb.PageController do
  use HexedioWeb, :controller
  import Ecto.Query
  alias Ecto.Query
  alias Hexedio.Posts
  alias Hexedio.Contact.ContactForm
  alias Hexedio.Posts.Post
  alias Hexedio.Auth.Guardian

  def index(conn, _params) do
    conn = put_layout(conn, false)
    render conn, "index.html"
  end

  def search(conn, %{"query" => query}) do
    page = Posts.search_posts(query)
    render(conn, "blog.html", posts: page.entries, page: page)
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

  def contact(conn, _params) do
    changeset = ContactForm.changeset(%ContactForm{}, %{}) 
    render(conn, "contact.html", changeset: changeset)
  end

  def contact_handler(conn, %{"contact_form" => contact_params}) do
    ContactForm.changeset(%ContactForm{}, contact_params)
  end
end
