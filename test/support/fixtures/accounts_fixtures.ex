defmodule TartuBike.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TartuBike.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        creditcard: "1111111111111111",
        dateofbirth: "27/09/1993",
        email: "some@email.ee",
        name: "some name",
        password: "some password",
        tartubusnumber: "2222222222222",
        username: "some username"
      })
      |> TartuBike.Accounts.create_user()

    user
  end




  @doc """
  Generate a membership.
  """
  def membership_fixture(attrs \\ %{}) do
    {:ok, membership} =
      attrs
      |> Enum.into(%{
        desc: "some desc"
      })
      |> TartuBike.Accounts.create_membership()

    membership
  end
end
