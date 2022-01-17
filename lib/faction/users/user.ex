defmodule Faction.Users.User do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]
  import Ecto.Changeset

  schema "users" do
    pow_user_fields()
    field :name, :string

    has_many :games_owned, Faction.Users.User, foreign_key: :owner_user_id, references: :id
    has_many :players, Faction.Games.Player

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:name])
  end
end
