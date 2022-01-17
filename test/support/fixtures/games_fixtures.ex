defmodule Faction.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Faction.Games` context.
  """

  import Faction.UsersFixtures

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do

    user = user_fixture()

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
        name: "some name",
        owner_user_id: user.id
      })
      |> Faction.Games.create_game()

    game
  end

  def player_fixture(user_id, game_id, attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        nickname: "some nickname",
        user_id: user_id,
        game_id: game_id,
      })
      |> Faction.Games.create_player()

      player
  end
end
