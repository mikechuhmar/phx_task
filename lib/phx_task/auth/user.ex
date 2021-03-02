defmodule PhxTask.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pbkdf2

  schema "users" do
    field :login, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:login, :name, :password])
    |> validate_required([:login, :name, :password])
    |> unique_constraint(:login)
    |> generate_password_hash
  end

  # defp validate_changeset(user) do
  #   user
  #   |> unique_constraint(:login)
  #   |> generate_password_hash
  # end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end



end
