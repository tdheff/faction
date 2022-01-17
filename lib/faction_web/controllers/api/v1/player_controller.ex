defmodule FactionWeb.API.V1.PlayerController do
  use FactionWeb, :controller

  alias Faction.Games
  alias Faction.Games.Player

  action_fallback FactionWeb.FallbackController

  def index(conn, %{"game_id" => game_id}) do
    players = Games.list_game_players(game_id)
    render(conn, "index.json", players: players)
  end

  def create(conn, %{"game_id" => game_id, "player" => player_params}) do
    with {:ok, %Player{} = player} <- Games.create_player(Map.put(player_params, "game_id", game_id)) do
      conn
      |> put_status(:created)
      |> render("show.json", player: player)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   game = Games.get_game!(id)
  #   render(conn, "show.json", game: game)
  # end

  # def update(conn, %{"id" => id, "game" => game_params}) do
  #   game = Games.get_game!(id)

  #   with {:ok, %Game{} = game} <- Games.update_game(game, game_params) do
  #     render(conn, "show.json", game: game)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   game = Games.get_game!(id)

  #   with {:ok, %Game{}} <- Games.delete_game(game) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
