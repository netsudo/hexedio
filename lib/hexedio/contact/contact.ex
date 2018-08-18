defmodule Hexedio.Contact.ContactForm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contact" do
    field :email, :string, virtual: true
    field :subject, :string, virtual: true
    field :body, :string, virtual: true
  end
  
  @doc false
  def changeset(contact, attrs \\ %{}) do
    contact
    |> cast(attrs, [:email, :subject, :body])
    |> validate_required([:email, :subject, :body])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 50)
    |> validate_length(:subject, min: 2)
    |> validate_length(:subject, max: 50)
    |> validate_length(:body, min: 20)
    |> validate_length(:subject, max: 3000)
  end
end
