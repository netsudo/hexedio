defmodule Hexedio.Posts.Post.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
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
    
    many_to_many :categories, Hexedio.Posts.Category, [join_through: "posts_categories", on_replace: :delete]

    timestamps()
  end

  @doc false
  def changeset(post, attrs \\ %{"categories" => []}) do
    IO.inspect attrs
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
