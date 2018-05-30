defmodule Hexedio.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :content, :string
    field :date_published, :date
    field :excerpt, :string
    field :published, :boolean, default: false
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :content, :excerpt, :date_published, :published])
    |> validate_required([:title, :slug, :content, :excerpt, :date_published, :published])
  end
end
