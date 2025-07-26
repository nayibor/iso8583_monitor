defmodule Iso8583Monitor.Interfaces.Interface do
  alias Iso8583Monitor.StringMap
  use Ecto.Schema
  import Ecto.Changeset

  schema "interfaces" do
    field :name, :string
    field :port, :integer
    field :status, :boolean, default: false
    field :address, :string
    field :description, :string
    field :pool_name, :string
    field :pool_type, Ecto.Enum, values: [:client, :server]
    field :specification, StringMap
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(interface, attrs) do
    interface
    |> cast(attrs, [:name,:description,:pool_name,:pool_type,:address,:port,:status,:specification])
    |> validate_required([:name,:description,:pool_name,:pool_type,:address,:port,:status,:specification])
    |> unique_constraint(:pool_name)
  end
end
