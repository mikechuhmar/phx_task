defmodule PhxTaskWeb.UserView do
  use PhxTaskWeb, :view
  alias PhxTaskWeb.UserView

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      login: user.login,
      name: user.name,
      password_hash: user.password_hash,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end



  def render("success.json", %{user: user, token: token}) do
    %{
      status: :ok,
      user: render_one(user, UserView, "user.json"),
      token: token
    }
  end

  def render("success.json", %{message: message}) do
    %{
      message: message
    }
  end

  def render("error.json", %{reason: reason}) do
    %{
      status: :error,
      reason: reason
    }
  end

  def render("some_action.json", %{var: var}) do
    %{
      var: var
    }
  end
end
