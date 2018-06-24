defmodule HexedioWeb.AdminController do
  use HexedioWeb, :controller

  alias Hexedio.Posts
  alias Hexedio.Posts.Post
  alias Hexedio.Posts.Category

  def index(conn, params) do
    #posts = Posts.list_posts()
    page = Post
            |> Hexedio.Repo.paginate(params)
    render(conn, "index.html", posts: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{categories: [%Category{}]})
    category_list = Posts.list_categories
    render(conn, "new.html", changeset: changeset, category_list: category_list)
  end

  def create(conn, %{"post" => post_params, "categories" => category_params}) do
    case Posts.create_post(post_params, category_params) do
      {:ok, %Post{} = post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: admin_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        category_list = Posts.list_categories
        render(conn, "new.html", category_list: category_list, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Post.changeset(%Post{categories: [%Category{}]})
    category_list = Posts.list_categories
    render(conn, "edit.html", post: post, changeset: changeset, category_list: category_list)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: admin_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_path(conn, :index))
  end
end
