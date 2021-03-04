defmodule PhxTask.AuthTest do
  use PhxTask.DataCase

  alias PhxTask.Auth
  alias Pbkdf2, as: Hash

  describe "users" do
    alias PhxTask.Auth.User

    @valid_attrs %{login: "some login", name: "some name", password: "some password"}
    @update_attrs %{
      login: "some updated login",
      name: "some updated name",
      password: "some updated password"
    }
    @invalid_attrs %{login: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, %User{} = user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      Map.put(user, :password, nil)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.get_user(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.login == "some login"
      assert user.name == "some name"
      assert Hash.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.login == "some updated login"
      assert user.name == "some updated name"
      assert Hash.verify_pass("some updated password", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert {:ok, %User{} = user} = Auth.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert {:error, :user_not_found} == Auth.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
