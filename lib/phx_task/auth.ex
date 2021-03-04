defmodule PhxTask.Auth do
  @moduledoc """
  The Auth context.
  """

  alias PhxTask.Repo
  alias PhxTask.Auth.User

  @doc """
  Creates a user.

  """
  def create_user(attrs \\ %{}) do
    changeset = User.changeset(%User{}, attrs)
    Repo.insert(changeset)
  end

  @doc """
  Gets a single user by id.

  """
  def get_user(id) do
    try do
      user = Repo.get!(User, id)
      {:ok, user}
    rescue
      Ecto.NoResultsError ->
        {:error, :user_not_found}
    end
  end

  @doc """
  Gets a single user by login.

  """
  def get_user_by_login(login) do
    try do
      user = Repo.get_by!(User, login: login)
      {:ok, user}
    rescue
      Ecto.NoResultsError ->
        {:error, :user_not_found}
    end
  end

  @doc """
  Returns the list of users.

  """
  def list_users do
    Repo.all(User)
  end

  def authenticate_user(login, password) do
    case get_user_by_login(login) do
      {:ok, user} ->
        check_password(user, password)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def authorizate_for_change(current_id, user_id, password) do
    if current_id == user_id do
      case get_user(user_id) do
        {:ok, user} ->
          check_password(user, password)

        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, :no_permission_to_change}
    end
  end

  defp check_password(user, password) do
    if Pbkdf2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
