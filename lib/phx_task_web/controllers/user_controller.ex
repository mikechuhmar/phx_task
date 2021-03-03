defmodule PhxTaskWeb.UserController do
  use PhxTaskWeb, :controller

  alias PhxTask.Auth
  alias PhxTask.Auth.Guardian
  alias PhxTaskWeb.Router.Helpers, as: Routes


  action_fallback PhxTaskWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Auth.get_user!(id)

  #   with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = Auth.get_user!(id)

  #   with {:ok, %User{}} <- Auth.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

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
        |> render("success.json", user: user, token: token)
      {:error, reason} ->
        conn
        |> render("error.json", reason: to_string(reason))
    end

  end

  def sign_in_by_token(conn, %{"token" =>token}) do

    case Guardian.resource_from_token(token) do
      {:ok, user, _} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)
        conn
        |> render("success.json", user: user, token: token)
      {:error, _} ->
        conn
        |> render("error.json", reason: :invalid_token)
    end
  end


  # def some_action(conn, _params) do
  #   var =Guardian.Plug.current_resource(conn)
  #   conn
  #   |> render("some_action.json", var: var.id)
  # end

end
