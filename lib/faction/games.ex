defmodule Faction.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Faction.Repo

  alias Faction.Games.Game
  alias Faction.Games.Player

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id) do
    Repo.get!(Game, id)
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Returns the list of players in a game.

  ## Examples

      iex> list_games(game_id)
      [%Player{}, ...]

  """
  def list_game_players(game_id) do
    Repo.all(from p in Player, where: p.game_id == ^game_id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a player, effectively adding a user to a game.

  ## Examples

      iex> create_player(%{game_id: 1, user_id: 2, nickname: hey})
      {:ok, %Player{...}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    insert =
      %Player{}
      |> Player.changeset(attrs)
      |> Repo.insert()

    case insert do
      {:ok, player} ->
        fetched_player =
          Repo.get!(Player, player.id)
          |> Repo.preload(:user)
        {:ok, fetched_player}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
