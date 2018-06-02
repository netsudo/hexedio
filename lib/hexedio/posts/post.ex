defmodule Hexedio.Posts.Post.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Hexedio.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hexedio.Posts.Post.TitleSlug


  schema "posts" do
    field :content, :string
    field :date_published, :date, default: Ecto.Date.utc
    field :excerpt, :string
    field :published, :boolean, default: false
    field :title, :string
    field :slug, TitleSlug.Type


    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :excerpt, :date_published, :published])
    |> validate_required([:title, :content, :excerpt, :date_published, :published])
    #Using ecto-autoslug-field to generate the slug
    |> unique_constraint(:title)
    |> TitleSlug.maybe_generate_slug
    |> TitleSlug.unique_constraint
  end
end

