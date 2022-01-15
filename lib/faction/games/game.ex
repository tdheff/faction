defmodule Faction.Games.Game do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]
  import Ecto.Changeset

  @adjudication_rates ["five_minutes", "fifteen_minutes", "thirty_minutes", "hour", "two_hour", "eight_hour", "twelve_hour", "day", "two_day", "week"]
  @communication_types ["none", "always", "limited"]

  schema "games" do
    field :adjudicate_on_weekends, :boolean, default: false
    field :adjudication_rate, :string
    field :adjudication_time, :time
    field :communication_type, :string
    field :description, :string
    field :instant_adjudication, :boolean, default: false
    field :is_anonymous, :boolean, default: false
    field :is_private, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :description, :is_private, :adjudication_rate, :adjudication_time, :adjudicate_on_weekends, :communication_type, :instant_adjudication, :is_anonymous])
    |> validate_required([:name, :description, :is_private, :adjudication_rate, :adjudication_time, :adjudicate_on_weekends, :communication_type, :instant_adjudication, :is_anonymous])
    |> validate_inclusion(:adjudication_rate, adjudication_rates())
    |> validate_inclusion(:communication_type, communication_types())
  end

  def adjudication_rates, do: @adjudication_rates
  def communication_types, do: @communication_types
end
