defmodule FactionWeb.API.V1.GameView do
  use FactionWeb, :view
  alias FactionWeb.API.V1.GameView
  alias FactionWeb.API.V1.PlayerView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{
      id: game.id,
      name: game.name,
      description: game.description,
      is_private: game.is_private,
      adjudication_rate: game.adjudication_rate,
      adjudication_time: game.adjudication_time,
      adjudicate_on_weekends: game.adjudicate_on_weekends,
      communication_type: game.communication_type,
      instant_adjudication: game.instant_adjudication,
      is_anonymous: game.is_anonymous,
      players: render_many(Map.get(game, :players), PlayerView, "index.json")
    }
  end
end
