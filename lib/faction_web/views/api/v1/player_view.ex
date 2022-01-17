defmodule FactionWeb.API.V1.PlayerView do
  use FactionWeb, :view
  alias FactionWeb.API.V1.UserView
  alias FactionWeb.API.V1.PlayerView

  def render("index.json", %{players: players}) do
    %{data: render_many(players, PlayerView, "player.json")}
  end

  def render("show.json", %{player: player}) do
    %{data: render_one(player, PlayerView, "player.json")}
  end

  def render("player.json", %{player: player}) do
    %{
      nickname: player.nickname,
      user: render_one(player.user, UserView, "user.json")
    }
  end
end
