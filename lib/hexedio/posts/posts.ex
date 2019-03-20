defmodule Hexedio.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Hexedio.Repo

  alias Hexedio.Posts.Post
  alias Hexedio.Posts.Category

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def list_post_categories!(id) do
    query = Repo.get!(Post, id) |> Repo.preload(:categories)
    for p <- query.categories, do: p.name
  end

  def search_posts(query) do
    wildcard_search = "%#{query}%"

    q = from p in Post,
      where: ilike(p.title, ^wildcard_search) and p.published == ^true,
      or_where: ilike(p.content, ^wildcard_search) and p.published == ^true,
      preload: [:categories]

    Hexedio.Repo.paginate(q)
  end

  @doc """
  Gets a single post by id.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id) |> Repo.preload(:categories)

  @doc """
  Gets a single post by slug.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_by_slug!(slug, published), do: Repo.get_by!(Post, [slug: slug, published: published])
  def get_post_by_slug!(slug), do: Repo.get_by!(Post, [slug: slug])

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(post, categories) do
    filter_unchecked = Enum.filter(categories, fn v -> elem(v,1) != "false" end)
    category_list = Map.keys(filter_unchecked)
    attrs = Map.put(post, "categories", category_list)

    %Post{}
      |> Post.changeset(attrs)
      |> Repo.insert()
      
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(postobj, post, categories) do
    filter_unchecked = :maps.filter fn _, v -> v != "false" end, categories
    category_list = Map.keys(filter_unchecked)
    attrs = Map.put(post, "categories", category_list)

    postobj
      |> Post.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end


  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_posts_by_category(category) do
    posts = from p in Post, 
      join: c in assoc(p, :categories),
      where: p.published == ^true and c.name == ^category,
      preload: [:categories]
    Hexedio.Repo.paginate(posts)
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
