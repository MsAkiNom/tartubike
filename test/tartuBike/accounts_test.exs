defmodule TartuBike.AccountsTest do
  use TartuBike.DataCase

  alias TartuBike.Accounts

  describe "users" do
    alias TartuBike.Accounts.User

    import TartuBike.AccountsFixtures

    @invalid_attrs %{creditcard: nil, dateofbirth: nil, email: nil, name: nil, password: nil, tartubusnumber: nil, username: nil}



    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{creditcard: "1234567890666666", dateofbirth: "27/09/1993", email: "some@email.ee", name: "some name", password: "some password", tartubusnumber: "1234567890333", username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.creditcard == "1234567890666666"
      assert user.dateofbirth == "27/09/1993"
      assert user.email == "some@email.ee"
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.tartubusnumber == "1234567890333"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{creditcard: "1111111111111111", dateofbirth: "07/07/1997", email: "updated@email.ee", name: "some updated name", password: "some updated password", tartubusnumber: "", username: "some updated username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.creditcard == "1111111111111111"
      assert user.dateofbirth == "07/07/1997"
      assert user.email == "updated@email.ee"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
      assert user.tartubusnumber == nil
      assert user.username == "some updated username"
    end



    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end


  describe "memberships" do
    alias TartuBike.Accounts.Membership

    import TartuBike.AccountsFixtures

    test "list_memberships/0 returns all memberships" do
      membership = membership_fixture()
      assert Accounts.list_memberships() == [membership]
    end

    test "get_membership!/1 returns the membership with given id" do
      membership = membership_fixture()
      assert Accounts.get_membership!(membership.id) == membership
    end


    test "delete_membership/1 deletes the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{}} = Accounts.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_membership!(membership.id) end
    end

    test "change_membership/1 returns a membership changeset" do
      membership = membership_fixture()
      assert %Ecto.Changeset{} = Accounts.change_membership(membership)
    end
  end
end
