defmodule Iso8583Monitor.Repo.Migrations.CreateRules do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :name, :string
      add :description, :string
      add :expression, :string
      add :tag, :string
      add :status, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
