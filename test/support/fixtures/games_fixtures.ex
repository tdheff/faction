defmodule Faction.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Faction.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        adjudicate_on_weekends: true,
        adjudication_rate: "day",
        adjudication_time: ~T[14:00:00],
        communication_type: "always",
        description: "some description",
        instant_adjudication: true,
        is_anonymous: true,
        is_private: true,
        name: "some name"
      })
      |> Faction.Games.create_game()

    game
  end
end
