defmodule Faction.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :description, :text
      add :is_private, :boolean, default: false, null: false
      add :adjudication_rate, :string
      add :adjudication_time, :time
      add :adjudicate_on_weekends, :boolean, default: false, null: false
      add :communication_type, :string
      add :instant_adjudication, :boolean, default: false, null: false
      add :is_anonymous, :boolean, default: false, null: false

      timestamps()
    end
  end
end
