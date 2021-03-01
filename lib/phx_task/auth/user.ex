defmodule PhxTask.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :login, :string
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:login, :name, :password_hash])
    |> validate_required([:login, :name, :password_hash])
  end
end
