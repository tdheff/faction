defmodule Faction.UsersFixtures do
  alias Faction.Users.User
  alias Faction.Repo

  @password "secret1234"

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Faction.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    %User{
      name: "test user",
      email: DateTime.to_string(DateTime.utc_now()) <> "@example.com",
      password: @password,
      password_hash: "fake_hash",
    }
    |> Map.merge(attrs)
    |> Repo.insert!()
  end
end
