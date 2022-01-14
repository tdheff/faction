defmodule Faction.Repo do
  use Ecto.Repo,
    otp_app: :faction,
    adapter: Ecto.Adapters.Postgres
end
