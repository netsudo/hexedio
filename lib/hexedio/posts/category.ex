defmodule Hexedio.Posts.Category do
  use Ecto.Schema
  import Ecto.Changeset


  schema "categories" do
    field :name, :string

    many_to_many :posts, Hexedio.Posts.Post, join_through: "posts_categories"

    timestamps()
  end

  @doc false
  def changeset(category, attrs \\ %{}) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
