defmodule Iso8583Monitor.Repo.Migrations.AddMaxConnectionAndHeaderSizeToInterfaces do
  use Ecto.Migration

  def change do
    alter table(:interfaces) do
      add :header_size, :integer
      add :max_connections, :integer
    end
  end
end
