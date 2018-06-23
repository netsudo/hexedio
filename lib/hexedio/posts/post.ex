defmodule Hexedio.Posts.Post.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug, always_change: true
end

defmodule Hexedio.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Hexedio.Repo
  alias Hexedio.Posts.Category
  alias Hexedio.Posts.Post.TitleSlug


  schema "posts" do
    field :content, :string
    field :date_published, :date, default: Ecto.Date.utc
    field :published, :boolean, default: false
    field :title, :string
    field :slug, TitleSlug.Type
    
<<<<<<< HEAD
    many_to_many :categories, Hexedio.Posts.Category, [join_through: "posts_categories", on_replace: :delete, on_delete: :delete_all]
=======
    many_to_many :categories, Hexedio.Posts.Category, [join_through: "posts_categories", on_replace: :delete]
>>>>>>> Using the actual put_assoc functionality in changeset now as opposed to rolling my own

    timestamps()
  end

  @doc false
  def changeset(post, attrs \\ %{"categories" => []}) do
<<<<<<< HEAD
=======
    IO.inspect attrs
>>>>>>> Using the actual put_assoc functionality in changeset now as opposed to rolling my own
    cat = Repo.all(from c in Category, where: c.name in ^attrs["categories"])

    post
    |> Repo.preload(:categories)
    |> cast(attrs, [:title, :content, :date_published, :published])
    |> put_assoc(:categories, cat)
    |> validate_required([:title, :content, :date_published, :published, :categories])
    #Using ecto-autoslug-field to generate the slug
    |> unique_constraint(:title)
    |> TitleSlug.maybe_generate_slug
    |> TitleSlug.unique_constraint
  end
end
