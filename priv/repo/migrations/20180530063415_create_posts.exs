defmodule Hexedio.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :excerpt, :text
      add :date_published, :date
      add :published, :boolean, default: false, null: false

      timestamps()
    end

  end
end
