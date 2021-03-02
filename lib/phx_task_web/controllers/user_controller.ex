defmodule PhxTaskWeb.UserController do
  use PhxTaskWeb, :controller

  alias PhxTask.Auth
  alias PhxTask.Auth.User
  alias PhxTask.Auth.Guardian
  alias PhxTask.Repo

  alias PhxTaskWeb.Router.Helpers, as: Routes


  action_fallback PhxTaskWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Auth.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.user_path(conn, :show, [user]))
  #     |> render("show.json", user: user)
  #   end
  # end

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


    # case Auth.create_user(user_params) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
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
end
