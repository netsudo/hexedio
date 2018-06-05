defmodule Hexedio.Repo.Migrations.AddGeneratedSlug do
  use Ecto.Migration
  # Generated with "mix ecto.gen.migration generate_slug"

  def change do
    alter table(:posts) do
      add :slug, :string
    end

    create unique_index(:posts, [:slug]) # Should be unique
  end

end
