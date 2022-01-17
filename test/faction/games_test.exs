defmodule Faction.GamesTest do
  use Faction.DataCase

  alias Faction.Games

  describe "games" do
    alias Faction.Games.Game
    alias Faction.Games.Player

    import Faction.GamesFixtures
    import Faction.UsersFixtures

    @invalid_attrs %{adjudicate_on_weekends: nil, adjudication_rate: nil, adjudication_time: nil, communication_type: nil, description: nil, instant_adjudication: nil, is_anonymous: nil, is_private: nil, name: nil}
    @invalid_player_attrs %{game_id: nil, user_id: nil, nickname: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      user = user_fixture()
      valid_attrs = %{adjudicate_on_weekends: true, adjudication_rate: "day", adjudication_time: ~T[14:00:00], communication_type: "always", description: "some description", instant_adjudication: true, is_anonymous: true, is_private: true, name: "some name", owner_user_id: user.id}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.adjudicate_on_weekends == true
      assert game.adjudication_rate == "day"
      assert game.adjudication_time == ~T[14:00:00]
      assert game.communication_type == "always"
      assert game.description == "some description"
      assert game.instant_adjudication == true
      assert game.is_anonymous == true
      assert game.is_private == true
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{adjudicate_on_weekends: false, adjudication_rate: "hour", adjudication_time: ~T[15:01:01], communication_type: "none", description: "some updated description", instant_adjudication: false, is_anonymous: false, is_private: false, name: "some updated name"}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.adjudicate_on_weekends == false
      assert game.adjudication_rate == "hour"
      assert game.adjudication_time == ~T[15:01:01]
      assert game.communication_type == "none"
      assert game.description == "some updated description"
      assert game.instant_adjudication == false
      assert game.is_anonymous == false
      assert game.is_private == false
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end

    test "list_players/0 returns all players" do
      game = game_fixture()
      user = user_fixture()
      player = player_fixture(user.id, game.id)

      assert Games.list_game_players(game.id) == [player]
    end

    test "create_player/1 with valid data creates a player" do
      game = game_fixture()
      user = user_fixture()

      valid_attrs = %{nickname: "nickname", user_id: user.id, game_id: game.id}

      assert {:ok, %Player{} = _player} = Games.create_player(valid_attrs)
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_player(@invalid_player_attrs)
    end
  end
end
