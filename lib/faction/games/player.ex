defmodule Faction.Games.Player do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]
  import Ecto.Changeset

  schema "players" do
    belongs_to :user, Faction.Users.User
    belongs_to :game, Faction.Games.Game
    field :nickname, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname, :game_id, :user_id])
    |> validate_required([:nickname, :game_id, :user_id])
  end
end
