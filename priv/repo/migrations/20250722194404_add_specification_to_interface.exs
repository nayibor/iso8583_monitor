defmodule Iso8583Monitor.Repo.Migrations.AddSpecificationToInterface do
  use Ecto.Migration

  def change do
    alter table(:interfaces) do
      add :specification, :text      
    end
  end
end
