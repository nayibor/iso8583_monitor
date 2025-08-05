defmodule Iso8583Monitor.Transactions.Rule do
  alias Iso8583Monitor.StringLua
  use Ecto.Schema
  import Ecto.Changeset

  schema "rules" do
    field :name, :string
    field :status, :boolean, default: false
    field :tag, :string
    field :description, :string
    field :expression, StringLua

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rule, attrs) do
    rule
    |> cast(attrs, [:name, :description, :expression, :tag, :status])
    |> validate_required([:name, :description, :expression, :tag, :status])
  end
end
