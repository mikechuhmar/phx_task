defmodule PhxTaskWeb.UserController do
  use PhxTaskWeb, :controller

  alias PhxTask.Auth
  alias PhxTask.Auth.User
  alias PhxTask.Auth.Guardian
  alias PhxTaskWeb.Router.Helpers, as: Routes
  alias Argon2, as: Hash

  action_fallback PhxTaskWeb.FallbackController

  def list(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    case Auth.get_user(id) do
      {:ok, user} ->
        render(conn, "show.json", user: user)

      {:error, reason} ->
        render(conn, "error.json", reason: reason)
    end
  end

  def update(conn, %{
        "id" => id,
        "password" => password,
        "user" => %{"name" => name, "password" => password}
      }) do
    with %User{} = current_user <- Guardian.Plug.current_resource(conn),
         {:ok, user} <- Auth.authorizate_for_change(current_user.id, id, password),
         {:ok, user} <- Auth.update_user(user, %{"name" => name, "password" => password}) do
      render(conn, "success.json", user: user)
    else
      nil ->
        render(conn, "error.json", reason: :no_authenticated)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, PhxTaskWeb.ChangesetView, "error.json", changeset: changeset)

      {:error, reason} ->
        render(conn, "error.json", reason: reason)
    end
  end

  def delete(conn, %{"id" => id, "password" => password}) do
    with %User{} = current_user <- Guardian.Plug.current_resource(conn),
         {:ok, user} <- Auth.authorizate_for_change(current_user.id, id, password),
         {:ok, user} <- Auth.delete_user(user) do
      render(conn, "success.json", user: user)
    else
      nil ->
        render(conn, "error.json", reason: :no_authenticated)

      {:error, reason} ->
        render(conn, "error.json", reason: reason)

      _other ->
        render(conn, "error.json", reason: :not_deleted)
    end
  end

  def sign_up(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, [user]))
        |> render("success.json", user: user, token: token)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhxTaskWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def sign_in(conn, %{"user" => %{"login" => login, "password" => password}}) do
    case Auth.authenticate_user(login, password) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)

        conn
        |> put_resp_header("location", Routes.user_path(conn, :show, [user]))
        |> render("show.json", user: user, token: token)

      {:error, reason} ->
        conn
        |> render("error.json", reason: to_string(reason))
    end
  end

  def sign_in_by_token(conn, %{"token" => token}) do
    case Guardian.resource_from_token(token) do
      {:ok, user, _} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)

        conn
        |> render("show.json", user: user, token: token)

      {:error, _} ->
        conn
        |> render("error.json", reason: :invalid_token)
    end
  end

  def some_action(conn, _params) do
    var = Guardian.Plug.current_resource(conn)

    conn
    |> render("some_action.json", var: var.id)
  end
end
