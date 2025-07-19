defmodule Iso8583Monitor.Repo.Migrations.CreateInterfaces do
  use Ecto.Migration

  def change do
    create table(:interfaces) do
      add :name, :string
      add :description, :string
      add :pool_name, :string
      add :pool_type, :string
      add :address, :string
      add :port, :integer
      add :status, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:interfaces, [:pool_name])
  end
end
